classdef ChessBoardGUI < handle
    properties
        ChessBoard
    end
    methods
        function this = ChessBoardGUI()
            this.ChessBoard = zeros(8,8);
            this = createGUI(this);
            this = placeFiguresStart(this);
        end
        
        function this = createGUI(this)
            h = figure('Name','Chess Master','Position',[0 0 1200 1200],...
                'MenuBar','none','NumberTitle','off','Color',[1 1 1]);
            for i=1:8
                for j=1:8
                    if mod(j,2) == 0  && mod(i,2)==0
                        bgc = [1 204/255 153/255];
                    elseif mod(j,2) ~= 0  && mod(i,2)~=0
                        bgc = [1 204/255 153/255];
                    else
                        bgc = [224/255 224/255 224/255];
                    end
                    btn = uicontrol('Style', 'pushbutton', 'String', '',...
                        'Position', [20+100*(j-1) 20+100*(i-1) 100 100],...
                        'BackGroundColor',bgc,...
                        'Parent',h,...
                        'SelectionHighlight','on',...
                        'Callback', '');
                    this.ChessBoard(i,j) = btn;
                end
            end
        end
        function this = placeFiguresStart(this)
            %Pawn placement
            set(this.ChessBoard(2,:),'CData',ChessBoardGUI.createRGB('resources/PW.png'));
            set(this.ChessBoard(7,:),'CData',ChessBoardGUI.createRGB('resources/PB.png'));
            %Roak placement
            set(this.ChessBoard(1,1),'CData',ChessBoardGUI.createRGB('resources/RW.png'));
            set(this.ChessBoard(1,8),'CData',ChessBoardGUI.createRGB('resources/RW.png'));
            set(this.ChessBoard(8,1),'CData',ChessBoardGUI.createRGB('resources/RB.png'));
            set(this.ChessBoard(8,8),'CData',ChessBoardGUI.createRGB('resources/RB.png'));
            %Knight placement
            set(this.ChessBoard(1,2),'CData',ChessBoardGUI.createRGB('resources/NW.png'));
            set(this.ChessBoard(1,7),'CData',ChessBoardGUI.createRGB('resources/NW.png'));
            set(this.ChessBoard(8,2),'CData',ChessBoardGUI.createRGB('resources/NB.png'));
            set(this.ChessBoard(8,7),'CData',ChessBoardGUI.createRGB('resources/NB.png'));
            %Bishop placement
            set(this.ChessBoard(1,3),'CData',ChessBoardGUI.createRGB('resources/BW.png'));
            set(this.ChessBoard(1,6),'CData',ChessBoardGUI.createRGB('resources/BW.png'));
            set(this.ChessBoard(8,3),'CData',ChessBoardGUI.createRGB('resources/BB.png'));
            set(this.ChessBoard(8,6),'CData',ChessBoardGUI.createRGB('resources/BB.png'));
            %Queen placement
            set(this.ChessBoard(1,4),'CData',ChessBoardGUI.createRGB('resources/QW.png'));
            set(this.ChessBoard(8,4),'CData',ChessBoardGUI.createRGB('resources/QB.png'));
            %King placement
            set(this.ChessBoard(1,5),'CData',ChessBoardGUI.createRGB('resources/KW.png'));
            set(this.ChessBoard(8,5),'CData',ChessBoardGUI.createRGB('resources/KB.png'));
        end
    end
    methods (Static)
        function playing_figure_rgb = createRGB(name)
            [playing_figure_rgb,~,alpha] = imread(name);
            playing_figure_rgb = double(playing_figure_rgb)/255;
            playing_figure_rgb((alpha/255)==0)= NaN;
        end
    end
end