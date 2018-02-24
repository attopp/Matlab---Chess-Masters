classdef ChessMasters
    %The main class that starts the game
    %Run this class to start a new game
    
    properties(Access = public)
        chessBoardModel;
        chessBoardGUI;
        gameController;
    end
    
    methods(Access = public)
        function this = ChessMasters()
            clc
            close
            addpath Model View Controller
            this.chessBoardModel = ChessBoardModel();
            this.gameController = GameController(this.chessBoardModel);
            this.chessBoardGUI = ChessBoardGUI(this.chessBoardModel,this.gameController);
        end
    end
end

