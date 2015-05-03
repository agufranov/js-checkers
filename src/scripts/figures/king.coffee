class @King extends Figure
    constructor: ({ @field, @player, @data }) ->
        super field: @field, type: 'king', player: @player, data: @data
