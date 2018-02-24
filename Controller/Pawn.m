classdef Pawn < Piece
    
    properties (GetAccess = public, Constant = true)
        id = 'P';
    end
    methods (Access = public)
        function this = Pawn(chessBoardModel, color, position)
            this = this@Piece(chessBoardModel, color, position);
        end
        %
        % Return coordinates of all valid moves
        %
        function path = ValidMoves(this)
            path = [];
            if(this.color == 'w')
                %Moving Up
                [y,~] = find(this.chessBoardModel.chessBoardMap(this.position(2):min(this.position(2)+2,8),this.position(1)),2);
                if(length(y)==1) %%there is no obstacle
                    if(this.used)
                        path = [this.position(1)*ones(1,1) (this.position(2)+1:this.position(2)+1)'];
                    else
                        path = [this.position(1)*ones(2,1) (this.position(2)+1:this.position(2)+2)'];
                    end
                elseif(length(y)==1 && (this.position(2)+1)>=8)%wall ready for promotion
                    path = [this.position(1)*ones(8-this.position(2),1) (this.position(2)+1:8)'];
                else
                    y(2)
                    y(1)
                    this.position(1)*ones(y(2)-y(1)-1,1)
                    (this.position(2)+1:this.position(2)+y(2)-y(1)-1)'
                    path = [this.position(1)*ones(y(2)-y(1)-1,1) (this.position(2)+1:this.position(2)+y(2)-y(1)-1)'];
                end
                if(this.position(2)~=8)
                %Diagonal move
                if(this.position(1)==1)
                    search =  this.chessBoardModel.chessBoardBoxes(this.position(1)+1,this.position(2)+1);
                elseif(this.position(1)==8)
                    search =  this.chessBoardModel.chessBoardBoxes(this.position(1)-1 ,this.position(2)+1);
                else
                    search =  this.chessBoardModel.chessBoardBoxes([this.position(1)-1 this.position(1)+1],this.position(2)+1);
                end
                for i = 1:size(search)
                    if(~isempty(search(i).button.UserData) && search(i).button.UserData.color == 'b')
                        path = [path; search(i).button.UserData.position]; %#ok
                    end
                end
                end
            else
                %Moving Down
                [y,~] = find(this.chessBoardModel.chessBoardMap(this.position(2):-1:max(this.position(2)-2,1),this.position(1)),2);
                if(length(y)==1) %%there is no obstacle
                    if(this.used)
                        path = [this.position(1)*ones(1,1) (this.position(2)-1:-1:this.position(2)-1)'];
                    else
                        path = [this.position(1)*ones(2,1) (this.position(2)-1:-1:this.position(2)-2)'];
                    end
                elseif((this.position(2)-1)>1)%wall ready for promotion
                    path = [this.position(1)*ones(y(2)-y(1)-1,1) (this.position(2)-1:-1:this.position(2)-y(2)+y(1)+1)'];
                end
                if(this.position(2)~=1)
                %Diagonal move
                if(this.position(1)==1)
                    search =  this.chessBoardModel.chessBoardBoxes(this.position(1)+1,this.position(2)-1);
                elseif(this.position(1)==8)
                    search =  this.chessBoardModel.chessBoardBoxes(this.position(1)-1 ,this.position(2)-1);
                elseif(this.position(2)~=1)
                    search =  this.chessBoardModel.chessBoardBoxes(this.position(1)-1,this.position(2)-1);
                    search = [search this.chessBoardModel.chessBoardBoxes(this.position(1)+1,this.position(2)-1)];
                end
                for i = 1:size(search,2)
                    if(~isempty(search(i).button.UserData) && search(i).button.UserData.color == 'w')
                        path = [path; search(i).button.UserData.position]; %#ok
                    end
                end
                end
            end
        end
    end
end