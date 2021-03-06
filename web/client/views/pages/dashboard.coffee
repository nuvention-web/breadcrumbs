$container = null
$matching = $()
groups = []

search_filter = ''
price_filter = [0, Infinity]
category_filter = ''
site_filter = []
subcategory_filter = []
brand_filter = []

filter_tab_placeholder = null
filter_tab_placeholder_default_value = null
filter_tab_placeholder_text = null

timer = null

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
        return Categories.find { count: {$gt: 0} }, {sort: {name: 1}}
    categoryDeleteTarget: () ->
        return Categories.findOne({filter_name: Session.get 'categoryDeleteTarget'})?.name if Session.get 'categoryDeleteTarget'
    sites: () ->
        return Sites.find()
    product_origin_image : (site) ->
        site_logo = site.toLowerCase().replace(/\s/g, '-')
        return "/images/logos/on-" + site_logo + ".png"
    parseSubcategories: (subcategories) ->
        return subcategories.toString()
    subcategories_db: () ->
        filter = Session.get('category_filter')
        if filter == 'all' or not filter
            return [{nothing: true}]
        else
            return Subcategories.find { super_category: filter, count: {$gt: 0} }
    brands: () ->
        filter = Session.get('category_filter')
        if filter == 'all' or not filter
            return [{nothing: true}]
        else
            return Brands.find { super_category: filter }
    category_filter_set: () ->
        filter = Session.get('category_filter')
        if filter == 'all' or not filter
            return false
        else
            return true

Template.dashboard.rendered = () ->
    Session.set('category_filter', 'all')
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

    # forces a reload everytime we find a new item in the database
    Items.find().observeChanges 
        added: (id, fields) ->
            parseFilters()

Template.dashboard.events
    'mouseover .item-div': (e) ->
        $(e.currentTarget).find('.item-delete').removeClass('invisible')   

    'mouseleave .item-div': (e) ->
        $(e.currentTarget).find('.item-delete').addClass('invisible') # class that's hidden but still takes up whitespace

    'click .item-delete': (event) ->
        id = $(event.currentTarget).parent().attr('data-id')
        category_name = $(event.currentTarget).parent().attr('data-category')
        subcategories = $(event.currentTarget).parent().attr('data-subcategories').split(',')

        
        Items.remove id

        if category_name
            category_id = (Categories.findOne {filter_name: category_name})._id
            Categories.update category_id, {$inc: {count: -1}}

        if subcategories
            subcategories_id = (Subcategories.findOne {filter_name: subcategories[0]})._id
            Subcategories.update subcategories_id, {$inc: {count: -1}}

    'click .cd-filter-trigger': (event) ->
        triggerFilter(true)

    'click .cd-filter .cd-close': (event) ->
        triggerFilter(false)

    'click .cd-tab-filter li': (event) ->
        # top tab filter event
        target = $(event.target)
        selected_filter = target.data('type')

        subcategory_filter = []
        brand_filter = []

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
            Session.set('category_filter', target.data('name'))
            category_filter = selected_filter
            parseFilters()

    'click #site-filters input': (event) ->
        $sites = $('#site-filters ul').find('input')
        site_filter = []
        for site in $sites
            if site.checked
                site_filter.push site.getAttribute('id')
        parseFilters()

    'keyup #price-filters input': (event) ->
        event.stopPropagation()
        update_price_filter(event.target.name, event.target.value)

    'change #price-filters input': (event) ->
        update_price_filter(event.target.name, event.target.value)

    'click #subcategory-filters': (event) ->
        $subcategories = $('#subcategory-filters ul').find('input')
        subcategory_filter = []
        for subcat in $subcategories
            if subcat.checked
                subcategory_filter.push subcat.getAttribute('id')
        parseFilters()

    'click #brand-filters': (event) ->
        $brands = $('#brand-filters ul').find('input')
        brand_filter = []
        for brand in $brands
            if brand.checked
                brand_filter.push brand.getAttribute('id')
        console.log brand_filter
        parseFilters()

    'click .cd-tab-filter .glyphicon-remove': (event) ->
        event.stopPropagation()
        Session.set 'categoryDeleteTarget', $(event.target).data('type')
        $('#confirm').modal('show')
    
    'click #confirm #categoryDelete': (event) ->
        category = Categories.findOne(filter_name: Session.get('categoryDeleteTarget'))
        Meteor.call 'deactivateCategory', category, Meteor.userId()

    'click .cd-filter-block h4': (event) ->
        current_target = $(event.currentTarget)
        current_target.toggleClass 'closed'
        current_target.siblings('.cd-filter-content').slideToggle 300

    'keyup .cd-filter-content input[type="search"]': (event) ->
        delay(() ->
            search_filter = $('.cd-filter-content input[type="search"]').val().toLowerCase();
            parseFilters()
        , 200)
        
    'submit form': (event) ->
        event.preventDefault()


Template.dashboard.destroyed = () ->
    $('.cd-gallery ul').mixItUp 'destroy', true


triggerFilter = ($bool) ->
    elementsToTrigger = $([$('.cd-filter-trigger'), $('.cd-filter'), $('.cd-tab-filter'), $('.cd-gallery')])
    elementsToTrigger.each(() ->
        $(this).toggleClass 'filter-is-visible', $bool)
        
fixGallery = () ->
    offsetTop = $('.cd-main-content').offset().top
    scrollTop = $(window).scrollTop()
    if scrollTop >= offsetTop
        $('.cd-main-content').addClass 'is-fixed'
    else
        $('.cd-main-content').removeClass 'is-fixed'

delay = (fn, ms) ->
    clearTimeout timer
    timer = setTimeout fn, ms

update_price_filter = (name, value) ->
    if name is 'min-price'
        index = 0
    else
        index = 1
    
    if value
        price_filter[index] = Number(value)
    else
        if index is 0
            price_filter[0] = 0
        else
            price_filter[1] = InfinityobserveChanges 

    parseFilters()

        
    
    

parseFilters = () ->
    $('.mix').each () ->
        $this = $(this)
        if passes_search_filter($this) and passes_category_filter($this) and passes_price_filter($this) and passes_site_filter($this) and passes_subcategory_filter($this) and passes_brand_filter($this)
            $matching = $matching.add this
        else
            $matching = $matching.not this

    $('.cd-gallery ul').mixItUp 'filter', $matching

passes_search_filter = (item) ->
    if search_filter.length > 0
        $item = $(item)
        if (($item.attr('class').toLowerCase().match search_filter) or ($item.find('.single-line-name').text().toLowerCase().match search_filter))
            return true
        else
            return false
    else
        return true

passes_site_filter = (item) ->
    $item = $(item)
    if site_filter.length == 0 or $item.data('site') in site_filter
        return true
    else
        return false

passes_price_filter = (item) ->
    $item = $(item)
    price = $item.data 'price'

    is_range = price.indexOf('-') is not -1
    if is_range
        prices = price.split('-')
        min_price = parseFloat(prices[0].replace(/[^\d\.]/g, ''))
        max_price = parseFloat(prices[1].replace(/[^\d\.]/g, ''))
        if (min_price >= price_filter[0] and min_price <= price_filter[1]) or (max_price >= price_filter[0] and max_price <= price_filter[1])
            return true
        else
            return false
    else
        price = parseFloat(price.replace(/[^\d\.]/g, '')) # replaces all non decimal or numeric chars
        if price >= price_filter[0] and price <= price_filter[1]
            return true
        else
            return false

passes_category_filter = (item) ->
    $item = $(item)
    category_filter = '' if category_filter == 'all'
    if category_filter == '' or $item.data('category') == category_filter
        return true
    else
        return false

passes_subcategory_filter = (item) ->
    $item = $(item)
    matchers = $item.data('subcategories').split(',')
    if subcategory_filter.length == 0
        return true
    console.log matchers
    for matcher in matchers
        if matcher in subcategory_filter
            return true
    return false

passes_brand_filter = (item) ->
    $item = $(item)
    if brand_filter.length == 0 or $item.data('brand') in brand_filter
        return true
    else
        return false
