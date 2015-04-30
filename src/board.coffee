# Создаем клетки в доске
@Board =
    fields: _.flatten [1..8].map (i) ->
        [1..8].map (j) ->
            x: i, y: j, color: if (i + j) % 2 is 0 then 'white' else 'black'

    figures: []
