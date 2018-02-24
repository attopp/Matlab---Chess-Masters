classdef GameController < handle
    properties (GetAccess = public, SetAccess = private)
        chessBoardModel;
        round;
    end
    methods
        function this = GameController(chessBoardModel)
            this.chessBoardModel = chessBoardModel;
            this.round = 1;
        end
        
        function playRound(this)
            this.round = this.round + 1;
        end
        %Check if any of the pieces of the king can stop the check either
        %by capturing the figure or blocking the path
        function boolean = blockThePathOrTakeIt(this,piece)
            if(piece.color == 'w')
                color = 'b';
            else
                color = 'w';
            end
            [y,x] = find(this.chessBoardModel.chessBoardMap ~= 75 & this.chessBoardModel.chessBoardMap ~= 0);
            linearindex = sub2ind(size(this.chessBoardModel.chessBoardBoxes), x, y);
            boxes = this.chessBoardModel.chessBoardBoxes(linearindex);
            buttons = [boxes.button];
            pieces = [buttons.UserData];
            colors = [pieces.color];
            paths = [];
            %Find pieces of opposite color
            indexes = find(colors == color);
            for i=1:length(indexes)
                paths = [paths; pieces(indexes(i)).ValidMoves]; %#ok
            end
            
            king = this.findKing(color);
            if((piece.id == 'N' || piece.id == 'P') && ~isempty(find(ismember(piece.position,paths,'rows'),1)))
                path = piece.position;
            elseif(piece.position(2) > king.position(2))
                %Rook or Queen
                if(piece.position(1) == king.position(1))
                    path = [piece.position(1)*ones(piece.position(2)-king.position(2)+1,1) (piece.position(2):-1:king.position(2))'];
                    %Bishop or Queen
                elseif(piece.position(1) > king.position(1))
                    path = [(king.position(1)+1:piece.position(1))' (king.position(2)+1:piece.position(2))'];
                else
                    path = [(king.position(1)-1:-1:piece.position(1))' (king.position(2)+1:piece.position(2))'];
                end
            elseif(piece.position(2) < king.position(2))
                %Rook or Queen
                if(piece.position(1) == king.position(1))
                    path = [piece.position(1)*ones(king.position(2)-piece.position(2)+1,1) (king.position(2):-1:piece.position(2))'];
                    %Bishop or Queen
                elseif(piece.position(1) > king.position(1))
                    path = [(piece.position(1)-1:-1:king.position(1))'    (king.position(2)-1:-1:piece.position(2))'];
                else
                    path = [(king.position(1)+1:piece.position(1))' (king.position(2)+1:piece.position(2))'];
                end
                %Bishop or Queen
            elseif(piece.position(2) == king.position(2))
                if(king.position(1) > piece.position(1))
                    path = [(king.position(1)-1:-1:piece.position(1))' piece.position(2)*ones(king.position(1)-piece.position(1),1)];
                else
                    path = [(king.position(1)+1:piece.position(1))' piece.position(2)*ones(piece.position(1)-king.position(1),1)];
                end
            end
            if(isempty(find(ismember(path,paths,'rows'),1)))
                boolean = 1;
            else
                boolean = 0;
            end
        end
        
        function boolean = checkPromotion(~,pawn)
            boolean = pawn.position(2) == 1 || pawn.position(2) == 8;
        end
        
        function boolean = checkCheckMate(this)
            boolean = isempty(this.findKing(this.whoPlays).ValidMoves);
        end
        
        function color = whoPlays(this)
            if(mod(this.round,2) == 0)
                color = 'b';
            else
                color = 'w';
            end
        end
        
        function king = findKing(this,color)
            [y,x] = find(this.chessBoardModel.chessBoardMap == 75);
            if(this.chessBoardModel.chessBoardBoxes(x(1),y(1)).button.UserData.color == color)
                king = this.chessBoardModel.chessBoardBoxes(x(1),y(1)).button.UserData;
            else
                king = this.chessBoardModel.chessBoardBoxes(x(2),y(2)).button.UserData;
            end
        end
        function placePieces(this)
            %Pawn placement
            for i = 1:8
                set(this.chessBoardModel.chessBoardBoxes(i,2).button,'CData',ChessBoardGUI.createRGB('resources/PW.png'),...
                    'UserData', Pawn(this.chessBoardModel,'w',[i 2]),'Enable','on');
                this.chessBoardModel.mapFifure([2 i],Pawn.id);
                
                set(this.chessBoardModel.chessBoardBoxes(i,7).button,'CData',ChessBoardGUI.createRGB('resources/PB.png'),...
                    'UserData', Pawn(this.chessBoardModel,'b',[i 7]),'Enable','on');
                this.chessBoardModel.mapFifure([7 i],Pawn.id);
            end
            %Rook placement
            set(this.chessBoardModel.chessBoardBoxes(1,1).button,'CData',ChessBoardGUI.createRGB('resources/RW.png'),...
                'UserData', Rook(this.chessBoardModel,'w',[1 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 1], Rook.id);
            
            set(this.chessBoardModel.chessBoardBoxes(8,1).button,'CData',ChessBoardGUI.createRGB('resources/RW.png'),...
                'UserData', Rook(this.chessBoardModel,'w',[8 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 8], Rook.id);
            
            set(this.chessBoardModel.chessBoardBoxes(1,8).button,'CData',ChessBoardGUI.createRGB('resources/RB.png'),...
                'UserData', Rook(this.chessBoardModel,'b',[1 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 1], Rook.id);
            
            set(this.chessBoardModel.chessBoardBoxes(8,8).button,'CData',ChessBoardGUI.createRGB('resources/RB.png'),...
                'UserData', Rook(this.chessBoardModel,'b',[8 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 8], Rook.id);
            
            %Knight placement
            set(this.chessBoardModel.chessBoardBoxes(2,1).button,'CData',ChessBoardGUI.createRGB('resources/NW.png'),...
                'UserData', Knight(this.chessBoardModel,'w',[2 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 2], Knight.id);
            
            set(this.chessBoardModel.chessBoardBoxes(7,1).button,'CData',ChessBoardGUI.createRGB('resources/NW.png'),...
                'UserData', Knight(this.chessBoardModel,'w',[7 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 7], Knight.id);
            
            set(this.chessBoardModel.chessBoardBoxes(2,8).button,'CData',ChessBoardGUI.createRGB('resources/NB.png'),...
                'UserData', Knight(this.chessBoardModel,'b',[2 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 2], Knight.id);
            
            set(this.chessBoardModel.chessBoardBoxes(7,8).button,'CData',ChessBoardGUI.createRGB('resources/NB.png'),...
                'UserData', Knight(this.chessBoardModel,'b',[7 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 7], Knight.id);
            
            %Bishop placement
            set(this.chessBoardModel.chessBoardBoxes(3,1).button,'CData',ChessBoardGUI.createRGB('resources/BW.png'),...
                'UserData', Bishop(this.chessBoardModel,'w',[3 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 3], Bishop.id);
            
            set(this.chessBoardModel.chessBoardBoxes(6,1).button,'CData',ChessBoardGUI.createRGB('resources/BW.png'),...
                'UserData', Bishop(this.chessBoardModel,'w',[6 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 6], Bishop.id);
            
            set(this.chessBoardModel.chessBoardBoxes(3,8).button,'CData',ChessBoardGUI.createRGB('resources/BB.png'),...
                'UserData', Bishop(this.chessBoardModel,'b',[3 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 3], Bishop.id);
            
            set(this.chessBoardModel.chessBoardBoxes(6,8).button,'CData',ChessBoardGUI.createRGB('resources/BB.png'),...
                'UserData', Bishop(this.chessBoardModel,'b',[6 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 6], Bishop.id);
            
            %Queen placement
            set(this.chessBoardModel.chessBoardBoxes(4,1).button,'CData',ChessBoardGUI.createRGB('resources/QW.png'),...
                'UserData', Queen(this.chessBoardModel,'w',[4 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 4], Queen.id);
            
            set(this.chessBoardModel.chessBoardBoxes(4,8).button,'CData',ChessBoardGUI.createRGB('resources/QB.png'),...
                'UserData', Queen(this.chessBoardModel,'b',[4 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 4], Queen.id);
            
            %King placement
            set(this.chessBoardModel.chessBoardBoxes(5,1).button,'CData',ChessBoardGUI.createRGB('resources/KW.png'),...
                'UserData', King(this.chessBoardModel,'w',[5 1]),'Enable','on');
            this.chessBoardModel.mapFifure([1 5], King.id);
            
            set(this.chessBoardModel.chessBoardBoxes(5,8).button,'CData',ChessBoardGUI.createRGB('resources/KB.png'),...
                'UserData', King(this.chessBoardModel,'b',[5 8]),'Enable','on');
            this.chessBoardModel.mapFifure([8 5], King.id);
        end
        
        function boolean = checkNoCoverCheck(this,color)
            king = this.findKing(color);
            boolean = (this.chessBoardModel.chessBoardBoxes(king.position(1),king.position(2)).button.UserData.checkForPossibleCheckBeforeMovingKing(king.position));
        end
        
        function boolean = checkCheck(this,piece)
            if(piece.color == 'w')
                color = 'b';
            else
                color = 'w';
            end
            king = this.findKing(color);
            %The king is in the future path of the moved figure = check
            if(~isempty(piece.ValidMoves))
                boolean = (~isempty(find(ismember(piece.ValidMoves,king.position,'rows'),1)));
            else
                boolean = 0;
            end
        end
    end
end
