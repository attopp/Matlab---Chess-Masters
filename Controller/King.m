classdef King < Piece
    
    properties (GetAccess = public, Constant = true)
        id = 'K';
    end
    
    methods (Access = public)
        function this = King(chessBoardModel, color, position)
            this = this@Piece(chessBoardModel, color, position);
        end
        
        function boolean = IsValidMove(this,newPosition)
            boolean = Piece.isMoveOnBoard(newPosition)&& checkForPossibleCheckBeforeMovingKing(this,newPosition) && freeOrEnemy(this,newPosition) && abs(newPosition(2) - this.position(2)) < 2 && abs(newPosition(1) - this.position(1)) < 2;
        end
        
        function boolean = freeOrEnemy(this,newPosition)
            boolean = isempty(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button.UserData) || ~isempty(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button.UserData) && this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button.UserData.color ~= this.color;
        end
        %Check if the king can move there and if not exclude it from the
        %path
        function boolean = checkOnBlackKing(this, newPosition)
            paths = [];
            %Virtually move king & store the previous info
            previousID = this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1));
            previousPiece=this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button.UserData;
            previousPosition = this.position;
            set(this.chessBoardModel.chessBoardBoxes(this.position(1),this.position(2)).button,'UserData','');
            set(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button,'UserData',this);
            this.chessBoardModel.chessBoardMap(this.position(2),this.position(1)) = 0;
            this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1)) = this.id;
            this.position = newPosition;
            
            %Find all pieces and their positions
            [y,x] = find(this.chessBoardModel.chessBoardMap ~= 75 & this.chessBoardModel.chessBoardMap ~= 0);
            linearindex = sub2ind(size(this.chessBoardModel.chessBoardBoxes), x, y);
            boxes = this.chessBoardModel.chessBoardBoxes(linearindex);
            buttons = [boxes.button];
            pieces = [buttons.UserData];
            colors = [pieces.color];
            
            %Find white pieces
            indexes = find(colors == 'w');
            
            for i=1:length(indexes)
                paths = [paths; pieces(indexes(i)).ValidMoves]; %#ok
            end
            
            %Move king back
            this.position = previousPosition;
            this.chessBoardModel.chessBoardMap(this.position(2),this.position(1)) = this.id;
            this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1)) = previousID;
            set(this.chessBoardModel.chessBoardBoxes(this.position(1),this.position(2)).button,'UserData',this);
            set(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button,'UserData',previousPiece);
            
            if(~isempty(paths))
                boolean = isempty(find(ismember(paths,newPosition,'rows'),1));
            else
                boolean = 1;
            end
        end
        function boolean = checkOnWhiteKing(this, newPosition)
            paths = [];
            %Virtually move king & store the previous info
            previousID = this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1));
            previousPiece=this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button.UserData;
            previousPosition = this.position;
            set(this.chessBoardModel.chessBoardBoxes(this.position(1),this.position(2)).button,'UserData','');
            set(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button,'UserData',this);
            this.chessBoardModel.chessBoardMap(this.position(2),this.position(1)) = 0;
            this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1)) = this.id;
            this.position = newPosition;
            
            %Find all pieces and their positions
            [y,x] = find(this.chessBoardModel.chessBoardMap ~= 75 & this.chessBoardModel.chessBoardMap ~= 0);
            linearindex = sub2ind(size(this.chessBoardModel.chessBoardBoxes), x, y);
            boxes = this.chessBoardModel.chessBoardBoxes(linearindex);
            buttons = [boxes.button];
            pieces = [buttons.UserData];
            colors = [pieces.color];
            
            %Find white pieces
            indexes = find(colors == 'b');
            
            for i=1:length(indexes)            
                paths = [paths; pieces(indexes(i)).ValidMoves]; %#ok
            end
            %Move king back
            this.position = previousPosition;
            this.chessBoardModel.chessBoardMap(this.position(2),this.position(1)) = this.id;
            this.chessBoardModel.chessBoardMap(newPosition(2),newPosition(1)) = previousID;
            set(this.chessBoardModel.chessBoardBoxes(this.position(1),this.position(2)).button,'UserData',this);
            set(this.chessBoardModel.chessBoardBoxes(newPosition(1),newPosition(2)).button,'UserData',previousPiece);
            if(~isempty(paths))
                boolean = isempty(find(ismember(paths,newPosition,'rows'),1));             
            else
                boolean = 1;
            end
        end
        function boolean = checkForPossibleCheckBeforeMovingKing(this,newPosition)
            if (this.color == 'w')
                boolean = this.checkOnWhiteKing(newPosition);
            else
                boolean = this.checkOnBlackKing(newPosition);
            end
        end
        %
        % Return coordinates of all valid moves
        %
        function path = ValidMoves(this)
            %Find objects/walls around
            path = [];
            if(this.IsValidMove(this.position+1))
                path = [path;this.position+1];
            end
            if (this.IsValidMove(this.position-1))
                path = [path;this.position-1];
            end
            if (this.IsValidMove(this.position+[1 -1]))
   
                path = [path;this.position+[1 -1]];
            end
            if (this.IsValidMove(this.position+[-1 1]))
               
                path = [path;this.position+[-1 1]];
            end
            if (this.IsValidMove(this.position+[1 0]))
          
                path = [path;this.position+[1 0]];
            end
            if (this.IsValidMove(this.position+[-1 0]))
                 
                path = [path;this.position+[-1 0]];
            end
            if (this.IsValidMove(this.position+[0 1]))
       
                path = [path;this.position+[0 1]];
            end
            if (this.IsValidMove(this.position+[0 -1]))
  
                path = [path;this.position+[0 -1]];
            end
        end
        
    end
end
