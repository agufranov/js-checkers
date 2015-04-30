# Создаем клетки в доске
@Board =
    # fieldsArray: []
    fields: _.flatten [1..8].map (i) ->
        [1..8].map (j) ->
            x: i, y: j, color: if (i + j) % 2 is 0 then 'white' else 'black'
    # fields: _.object [1..8].map( (i) ->
    #     [
    #         i,
    #         _.object [1..8].map( (j) ->
    #             field = { x: i, y: j, color: if (i + j) % 2 is 0 then 'white' else 'black' }
    #             @fieldsArray.push field
    #             [ j, field ]
    #         )
    #     ]
    # )

    figures: []

    fillWithCheckers: ->
        @figures = _(@fields)
            .filter (f) -> f.color is 'black' and (f.x <= 3 or f.x >= 6)
            # .forEach (f) -> f.color = 'test'
            .map (f) -> { field: f, type: 'checker', color: if f.x >= 6 then 'white' else 'black' }

Board.fillWithCheckers()
