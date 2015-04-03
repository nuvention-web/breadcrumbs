require.config({
    paths: {
        htmlparser: '.scr/lib/htmlparser'
    },
    shim: {
        'htmlparser': {
            exports: 'htmlparser'
        }
    }
});

require(['htmlparser'], function(htmlparser) {
    'use strict';

    console.log('READy');
    console.log(htmlparser);
});