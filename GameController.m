classdef GameController < handle
    properties
        chessBoardModel;
        pieces;        
    end
    methods
        function this = GameController()
            this.chessBoardModel = ChessBoardModel;
        end
    end    
end