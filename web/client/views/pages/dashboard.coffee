$container = null
$matching = $()
groups = []

filter_tab_placeholder = null
filter_tab_placeholder_default_value = null
filter_tab_placeholder_text = null

Template.dashboard.helpers
    items: () ->
        one_year_ago = new Date().getTime() - (1000 * 365 * 24 * 3600)
        return Items.find(
            {status: {$ne: 'inactive'}, most_recent_close: {$gte: one_year_ago}},
            {sort: {most_recent_close: -1}}
        )
    hasImage: (src) ->
        return src is not '/'
    categories: () ->
        return Categories.find {'items.0': {$exists: true}, status: {$ne: 'inactive'}}
    categoryDeleteTarget: () ->
        return Categories.findOne({filter_name: Session.get 'categoryDeleteTarget'}).name if Session.get 'categoryDeleteTarget'
    price_filter: (price) ->
        is_range = price.indexOf('-') is not -1
        if is_range
            console.log 'range, do this'
            return '1'
        else
            return determinePriceRange(parseFloat(price.substr(1)))
    product_origin : (site) ->
        site_logo = site.substring(0, site.indexOf('.'))
        return "/images/logos/on-" + site_logo + ".png"


Template.dashboard.rendered = () ->
    Session.set('categoryDeleteTarget', 0)

    filter_tab_placeholder = $('.cd-tab-filter .placeholder a') #get category name
    filter_tab_placeholder_default_value = 'Select'
    filter_tab_placeholder_text = filter_tab_placeholder.text()

    $(window).on('scroll', () ->
        if not window.requestAnimationFrame
            fixGallery()
        window.requestAnimationFrame(fixGallery)
    )

    $filters = $('.cd-main-content')
    $filters.find('.cd-filters').each(() ->
        $this = $(this)

        groups.push(
            $inputs: $this.find '.filter'
            active: ''
            tracker: false
        )
    )
    $container = $('.cd-gallery ul')

    $('.cd-gallery ul').mixItUp(
        controls:
            enable: false
        callbacks:
            onMixStart: () ->
                $('.cd-fail-message').fadeOut 200
            onMixFail: ()->
                $('.cd-fail-message').fadeIn 200
    )

    $('#confirm').modal({show: false})

    delay()

Template.dashboard.events
    'mouseover .item-div': (e) ->
        $(e.currentTarget).find('.item-delete').removeClass('invisible')   

    'mouseleave .item-div': (e) ->
        $(e.currentTarget).find('.item-delete').addClass('invisible') # class that's hidden but still takes up whitespace

    'click .item-delete': (event) ->
        id = $(event.currentTarget).parent().attr('data-id')
        category_name = $(event.currentTarget).parent().attr('data-category')
        
        Items.update(id, {$set: {status: 'inactive'}})

        category = Categories.findOne {filter_name: category_name}
        items = category.items
        index = items.indexOf id
        items.splice index, 1
        Categories.update category._id, {$set: {items: items}}

    'click .cd-filter-trigger': (event) ->
        triggerFilter(true)

    'click .cd-filter .cd-close': (event) ->
        triggerFilter(false)

    'click .cd-tab-filter li': (event) ->
        # top tab filter event
        target = $(event.target)
        selected_filter = target.data('type')

        # check if placeholder
        if target.is(filter_tab_placeholder)
            if filter_tab_placeholder_default_value is filter_tab_placeholder.text()
                filter_tab_placeholder.text(filter_tab_placeholder_text)
            else
                filter_tab_placeholder.text(filter_tab_placeholder_default_value)
            $('cd-tab-filter').toggleClass 'is-open'
        else if filter_tab_placeholder.data('type') is selected_filter
            # clicked already selected filter
            filter_tab_placeholder.text(target.text())
            $('.cd-tab-filter').removeClass('is-open')
        else
            # click new filter
            $('.cd-tab-filter').removeClass('is-open')
            filter_tab_placeholder.text(target.text()).data('type', selected_filter)
            filter_tab_placeholder_text = target.text()

            $('.cd-tab-filter .selected').removeClass 'selected'
            target.addClass 'selected'
            parseFilters()

    'click .cd-main-content a': (event) ->
        parseFilters()

    'change .cd-main-content': (event) ->
        parseFilters()

    'click .cd-tab-filter .glyphicon-remove': (event) ->
        event.stopPropagation()
        Session.set 'categoryDeleteTarget', $(event.target).parent().attr('data-filter').substr(1)
        $('#confirm').modal('show')
    
    'click #confirm #categoryDelete': (event) ->
        id = Categories.findOne(filter_name: Session.get('categoryDeleteTarget'))._id
        Categories.update(
            id,
            {$set: 
                status: 'inactive'
                deactivate_time: new Date().getTime()
            }
        )

    'click .cd-filter-block h4': (event) ->
        current_target = $(event.currentTarget)
        current_target.toggleClass 'closed'
        current_target.siblings('.cd-filter-content').slideToggle 300

    'keyup .cd-filter-content input[type="search"]': (event) ->
        console.log 'hi'
        # delay () ->
        input = $('.cd-filter-content input[type="search"]').val().toLowerCase();
        if input.length > 0
            $('.mix').each () ->
                $this = $(this)
                if $this.attr('class').toLowerCase().match input
                    $matching = $matching.add this
                else
                    $matching = $matching.not this
            $('.cd-gallery ul').mixItUp 'filter', $matching
        else
            $('.cd-gallery ul').mixItUp 'filter', 'all'

    'submit form': (event) ->
        event.preventDefault()

Template.dashboard.destroyed = () ->
    $('.cd-gallery ul').mixItUp 'destroy', true


triggerFilter = ($bool) ->
    elementsToTrigger = $([$('.cd-filter-trigger'), $('.cd-filter'), $('.cd-tab-filter'), $('.cd-gallery')])
    elementsToTrigger.each(() ->
        $(this).toggleClass 'filter-is-visible', $bool)

fixGallery = () ->
    # offsetTop = $('.cd-main-content').offset().top
    scrollTop = $(window).scrollTop()
    if scrollTop >= offsetTop
        $('.cd-main-content').addClass 'is-fixed'
    else
        $('.cd-main-content').removeClass 'is-fixed'

delay = () ->
        timer = 0
        return (callback, ms) ->
            clearTimeout timer
            timer = setTimeout callback, ms

parseFilters = () ->
    console.log 'fire'
    for group in groups
        group.active = []
        group.$inputs.each( () ->
            $this = $(this)
            if $this.is('input[type="radio"]') or $this.is('input[type="checkbox"]')
                if $this.is ':checked'
                    group.active.push $this.attr('data-filter')

            else if $this.is('select')
                group.active.push $this.val()

            else if $this.find('.selected').length > 0 
                group.active.push $this.attr('data-filter')
        )

    outputString = ''

    for group in groups
        outputString += group.active

    if outputString.length is 0
        outputString = 'all'

    if $container.mixItUp 'isLoaded'
        $container.mixItUp 'filter', outputString

determinePriceRange = (price) ->
    if price < 50
        return 'price1'
    else if price <= 100
        return 'price2'
    else
        return 'price3'