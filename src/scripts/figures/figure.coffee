class @Figure
    constructor: ({ @field, @type, @player, @data }) ->
        @isKilled = false
        @canMove = (field) -> throw new Error 'Not implemented'
        @move = (to) -> throw new Error 'Not implemented'
