classdef ChessBoardModel < handle
    properties
        chessBoard=[];
        pieces;
    end
    methods
        function this = ChessBoardModel()
            this = markBoxes(this);
        end
        
        function this = markBoxes(this)
            boxes(1:8, 1:8) = BoardSquare(0,0);
            this.chessBoard = boxes;
            for i= 1:8
                for j= 1:8
                    if mod(j,2) == 0  && mod(i,2)==0
                        bgc = [1 204/255 153/255];
                    elseif mod(j,2) ~= 0  && mod(i,2)~=0
                        bgc = [1 204/255 153/255];
                    else
                        bgc = [224/255 224/255 224/255];
                    end
                    this.chessBoard(i,j) = BoardSquare([i j], bgc);
                end
            end
        end
        
        
    end
end
