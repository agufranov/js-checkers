require ['util', 'board', 'game', 'figures/figure', 'figures/checkers/checker', 'figures/checkers/checker-pawn', 'figures/checkers/checker-king'], ->
    mocha.ui 'bdd'
    mocha.reporter 'html'
    expect = chai.expect

    describe 'Game', ->
        [cols, rows] = [8, 8]
        game = new Game
            boardData: { cols: cols, rows: rows }
            playersData: [{ number: 1, color: 'beige' }, { number: 2, color: 'black' }]

        window.game = game # debug

        game.board.figures = []
        game.board.addPawn(4, 3, 1)
        game.board.addPawn(3, 4, 1)
        game.board.addPawn(6, 5, 2)

        it 'should have board with cols and rows as declared', ->
            expect(game.board.cols).to.be.equal(cols)
            expect(game.board.rows).to.be.equal(rows)

        it 'should initially have state named new', ->
            expect(game.state.name).to.be.equal 'new'

        describe 'checker', ->
            figure = game.board.getFigureAt 4, 3

            it 'should be present', ->
                expect(figure).to.exist

            it 'should can not move to occupied field', ->
                figure.move col: 3, row: 4
                expect(figure.field.col).to.be.equal 4
                expect(figure.field.row).to.be.equal 3

            it 'should can move forwards to adjacent field', ->
                figure.move col: 5, row: 4
                expect(figure.field.col).to.be.equal 5
                expect(figure.field.row).to.be.equal 4

            it 'should not can move backwards to adjacent field', ->
                figure.move col: 4, row: 3
                expect(figure.field.col).to.be.equal 5
                expect(figure.field.row).to.be.equal 4

            it 'should can attack', ->
                expect(figure.canAttack()).to.be.not.false

            it 'should attack', ->
                figure.move col: 7, row: 6

            it 'should be game over if there is no more enemy figures', ->
                expect(game.state.name).to.be.equal 'gameover'

            it 'should be winner and it must be the first player', ->
                expect(game.state.winner).to.be.equal 1
    mocha.run()
