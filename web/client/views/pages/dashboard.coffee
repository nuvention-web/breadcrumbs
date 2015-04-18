filter_tab_placeholder = null
filter_tab_placeholder_default_value = null
filter_tab_placeholder_text = null

Template.dashboard.helpers
    items: () ->
        return Items.find()
    categories: () ->
        return Categories.find()

Template.dashboard.rendered = () ->
    filter_tab_placeholder = $('.cd-tab-filter .placeholder a') #get category name
    filter_tab_placeholder_default_value = 'Select'
    filter_tab_placeholder_text = filter_tab_placeholder.text()

    console.log filter_tab_placeholder

    $(window).on('scroll', () ->
        if not window.requestAnimationFrame
            fixGallery()
        window.requestAnimationFrame(fixGallery)
    )

    buttonFilter.init()
    $('.cd-gallery ul').mixItUp(
        controls:
            enable: false
        callbacks:
            onMixStart: () ->
                $('.cd-fail-message').fadeOut 200
            onMixFail: ()->
                $('.cd-fail-message').fadeIn 200
    )

    delay()
    @matching = $()

Template.dashboard.events
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
    'click .cd-filter-block h4': (event) ->
        current_target = $(event.currentTarget)
        current_target.toggleClass 'closed'
        current_target.siblings('.cd-filter-content').slideToggle 300
    'keyup cd-filter-content input[type="search"]': (event) ->
        delay () ->
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

delay = () ->
        timer = 0
        return (callback, ms) ->
            clearTimeout timer
            timer = setTimeout callback, ms

buttonFilter = 

    $filters: null
    groups: []
    outputArray: []
    outputString: ''

    init: () ->
        self = this

        self.$filters = $('.cd-main-content')
        self.$container = $('.cd-gallery ul')

        self.$filters.find('.cd-filters').each(() ->
            $this = $(this)

            self.groups.push(
                $inputs: $this.find '.filter'
                active: ''
                tracker: false
            )
        )

        self.bindHandlers()

    bindHandlers: () ->
        self = this

        self.$filters.on('click', 'a', (event) ->
            self.parseFilters()
        )
        self.$filters.on('change', () ->
            self.parseFilters()
        )

    parseFilters: () ->
        self = this

        for group in self.groups
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

        self.concatenate()

    concatenate: () ->
        self = this

        self.outputString = ''

        for group in self.groups
            self.outputString += group.active

        if self.outputString.length is 0
            self.outputString = 'all'

        if self.$container.mixItUp 'isLoaded'
            self.$container.mixItUp 'filter', self.outputString










