$ ->
    Vue.filter 'position', (value) ->
        "#{(parseInt(value) - 1) * 100}px"

    window.v = new Vue
        el: '.container'
        data:
            state: 'play'
            players: [ {
                number: 1
                name: 'Игрок 1'
            }, {
                number: 2
                name: 'Игрок 2'
            } ]
            board: Board
            figures: []
        computed:
            stateNew: -> @state is 'new'
            stateNotNew: -> @state isnt 'new'
        methods:
            new_click: ->
                @state = 'new'
            play_click: ->
                @state = 'play'

    v.figures.push type: 'checker'
    v.figures.push type: 'checker'
