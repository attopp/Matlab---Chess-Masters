classdef ChessBoardGUI < handle
    properties (GetAccess = public, SetAccess = private)
        gameController
        chessBoardModel
        previousClicked = struct('button',[],'buttonColor',[],'i',[],'j',[]);
    end
    methods
        function this = ChessBoardGUI(chessBoardModel,gameController)
            this.gameController = gameController;
            this.chessBoardModel = chessBoardModel;
            createGUI(this);
            this.gameController.placePieces;
        end
        function createGUI(this)
            h = figure('Name','Chess Master','Position',[300 200 850 1200],...
                'MenuBar','none','NumberTitle','off','Color',[1 1 1],'Resize', 'off');
            Letters = 'ABCDEFGH';
            for y=1:8
                for x=1:8
                    btn = uicontrol('Style', 'pushbutton', 'String', '',...
                        'Position', [20+100*(y-1) 375+100*(x-1) 100 100],...
                        'BackGroundColor',this.chessBoardModel.chessBoardBoxes(y,x).color,...
                        'Parent',h,...
                        'Enable','on',...
                        'Callback',{@this.board_button_callback, y, x});
                    uicontrol('Style','text',...
                        'Position',[60+100*(y-1) 355 20 20],...
                        'FontSize',15,...
                        'BackGroundColor',[1 1 1],...
                        'String',Letters(y));
                    uicontrol('Style','text',...
                        'Position',[60+100*(y-1) 375+100*8 20 20],...
                        'FontSize',15,...
                        'BackGroundColor',[1 1 1],...
                        'String',Letters(y));
                    uicontrol('Style','text',...
                        'Position',[0 425+100*(x-1) 20 20],...
                        'FontSize',15,...
                        'BackGroundColor',[1 1 1],...
                        'String',x);
                    uicontrol('Style','text',...
                        'Position',[20+100*8 425+100*(x-1) 20 20],...
                        'FontSize',15,...
                        'BackGroundColor',[1 1 1],...
                        'String',x);
                    this.chessBoardModel.chessBoardBoxes(y,x).setButton(btn);
                end
            end
            this.gameController.placePieces;
        end
        
        function board_button_callback(this, btn, ~, i, j)
            
            if(~isempty(btn.UserData) && this.gameController.whoPlays == btn.UserData.color)
                %Is it same color as the piece of player on turn?
                if(btn.UserData.color == this.gameController.whoPlays) % If Yes
                    %First Click
                    if(isempty(this.previousClicked.button))
                        set(btn,'BackGroundColor',[1 1 0]);
                        this.chessBoardModel.chessBoardBoxes(i,j).clicked = true;
                        this.highlightPath(btn.UserData.ValidMoves);
                    else
                        if(~this.chessBoardModel.chessBoardBoxes(i,j).clicked && btn == this.previousClicked.button)
                            set(btn,'BackGroundColor',[1 1 0]);
                            this.chessBoardModel.chessBoardBoxes(i,j).clicked = true;
                            this.highlightPath(btn.UserData.ValidMoves);
                            
                        elseif(~this.chessBoardModel.chessBoardBoxes(i,j).clicked && btn ~= this.previousClicked.button)
                            set(btn,'BackGroundColor',[1 1 0]);
                            this.chessBoardModel.chessBoardBoxes(i,j).clicked = true;
                            this.deselectButton;
                            this.highlightPath(btn.UserData.ValidMoves);
                        else
                            this.deselectButton;
                        end
                    end
                end
                this.previousClicked.button = btn;
                this.previousClicked.buttonColor = this.chessBoardModel.chessBoardBoxes(i,j).color;
                this.previousClicked.i = i;
                this.previousClicked.j = j;
            elseif(~isempty(this.previousClicked.button) && this.gameController.whoPlays == this.previousClicked.button.UserData.color)
                path = this.previousClicked.button.UserData.ValidMoves;
                if(~isempty(path)&&~isempty(find(path(1:end,1)==i & path(1:end,2)==j,1)))
                    %Move Image and the figure in GUI
                    this.deselectButton;
                    LastButtonPicture = this.previousClicked.button.CData;
                    movedPiece = this.previousClicked.button.UserData.movePiece([i j]);
                    Target = this.chessBoardModel.chessBoardBoxes(i,j).button.UserData;
                    TargetPicture = this.chessBoardModel.chessBoardBoxes(i,j).button.CData;
                    this.chessBoardModel.chessBoardBoxes(this.previousClicked.i,this.previousClicked.j).clicked = false;
                    this.chessBoardModel.chessBoardBoxes(i,j).clicked = true;
                    
                    if(movedPiece.id == 'P' && this.gameController.checkPromotion(movedPiece))
                        this.promote(movedPiece);
                    end
                    
                    set(this.chessBoardModel.chessBoardBoxes(i,j).button,'CData',this.previousClicked.button.CData,...
                        'UserData',movedPiece);
                    set(this.chessBoardModel.chessBoardBoxes(this.previousClicked.i,this.previousClicked.j).button,'CData',[],...
                        'UserData','');
                    set(this.previousClicked.button,'BackGroundColor',this.previousClicked.buttonColor);
                    
                    if(movedPiece.id ~= 'K' && ~this.gameController.checkNoCoverCheck(movedPiece.color))
                        movedPiece = movedPiece.movePiece([this.previousClicked.i this.previousClicked.j]);
                        this.chessBoardModel.chessBoardBoxes(i,j).clicked = false;
                        if(~isempty(Target))
                            set(this.chessBoardModel.chessBoardBoxes(Target.position(1),Target.position(2)).button,'CData',TargetPicture,...
                                'UserData',Target);
                            this.chessBoardModel.chessBoardMap(j,i) = this.chessBoardModel.chessBoardBoxes(i,j).button.UserData.id;
                        else
                            set(this.chessBoardModel.chessBoardBoxes(i,j).button,'CData',[],...
                                'UserData','');
                            this.chessBoardModel.chessBoardMap(j,i) = 0;
                            movedPiece.used = false;
                            this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button.UserData.used = false;
                        end
                        set(this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button,'CData',LastButtonPicture,...
                            'UserData',movedPiece);
                        
                        this.notifyNoCoverCheck;
                    else
                        this.gameController.playRound;
                        if(this.chessBoardModel.chessBoardBoxes(i,j).button.UserData.color == 'w')
                            color = 'b';
                        else
                            color = 'w';
                        end
                        if(this.gameController.checkCheck(this.chessBoardModel.chessBoardBoxes(i,j).button.UserData) || ~this.gameController.checkNoCoverCheck(color))
                            if(this.gameController.checkCheckMate && this.gameController.blockThePathOrTakeIt(movedPiece))
                                this.notifyEnd;
                            else
                                this.notifyCheck;
                            end
                        end
                    end
                end
                this.previousClicked.button = [];
                this.previousClicked.buttonColor = [];
                this.previousClicked.i = [];
                this.previousClicked.j = [];
            end
        end
        
        function deselectButton(this)
            set(this.previousClicked.button,'BackGroundColor',this.previousClicked.buttonColor);
            this.deselectPath(this.previousClicked.button.UserData.ValidMoves);
            this.chessBoardModel.chessBoardBoxes(this.previousClicked.i,this.previousClicked.j).clicked = false;
        end
        
        function deselectPath(this,path)
            for i =1:size(path,1)
                set(this.chessBoardModel.chessBoardBoxes(path(i,1),path(i,2)).button,'BackGroundColor',this.chessBoardModel.chessBoardBoxes(path(i,1),path(i,2)).color);
            end
        end
        
        function highlightPath(this,path)
            for i =1: size(path,1)
                set(this.chessBoardModel.chessBoardBoxes(path(i,1),path(i,2)).button,'BackGroundColor',[0 1 0]);
            end
        end
        
        function notifyCheck(this)
            if (this.gameController.whoPlays == 'w')
                msg = 'white';
                bg = [1 1 1];
                fnt = [0 0 0];
            else
                msg = 'black';
                bg = [0 0 0];
                fnt = [1 1 1];
            end
            warning = dialog('Name','Check','Position',[500 500 300 150],...
                'Resize','off',...
                'Color',bg);
            uicontrol('Style', 'pushbutton', 'String', 'Close',...
                'Position', [110 20  80 30],...
                'Parent',warning,...
                'Enable','on',...
                'Callback','close');
            uicontrol('Style', 'text', 'String', ['The ' msg ' king is checked!'],...
                'FontSize',22,...
                'Position',[0 70  300 30],...
                'BackGroundColor',bg,...
                'ForeGroundColor',fnt,...
                'Parent',warning);
        end
        
        function notifyEnd(this)
            if (this.gameController.whoPlays == 'w')
                msg = 'black';
                bg = [1 1 1];
                fnt = [0 0 0];
            else
                msg = 'white';
                bg = [0 0 0];
                fnt = [1 1 1];
            end
            warning = dialog('Name','End','Position',[500 500 300 150],...
                'Resize','off',...
                'Color',bg);
            uicontrol('Style', 'pushbutton', 'String', 'Close',...
                'Position', [140 20  80 30],...
                'Parent',warning,...
                'Enable','on',...
                'Callback','close all');
            uicontrol('Style', 'pushbutton', 'String', 'New Game',...
                'Position', [60 20  80 30],...
                'Parent',warning,...
                'Enable','on',...
                'Callback',@PushB);
            uicontrol('Style', 'text', 'String', ['The ' msg ' player has won!'],...
                'FontSize',22,...
                'Position',[0 70  300 30],...
                'BackGroundColor',bg,...
                'ForeGroundColor',fnt,...
                'Parent',warning);
            function PushB(~,~)
                close;
                run ChessMasters;
            end
        end
        
        function notifyNoCoverCheck(this)
            if (this.gameController.whoPlays == 'w')
                msg = 'white';
                bg = [1 1 1];
                fnt = [0 0 0];
            else
                msg = 'black';
                bg = [0 0 0];
                fnt = [1 1 1];
            end
            warning = dialog('Name','Check','Position',[500 500 600 150],...
                'Resize','off',...
                'Color',bg);
            uicontrol('Style', 'pushbutton', 'String', 'Close',...
                'Position', [260 20  80 30],...
                'Parent',warning,...
                'Enable','on',...
                'Callback','close');
            uicontrol('Style', 'text', 'String', ['Invalid move! The ' msg ' king would be checked!'],...
                'FontSize',22,...
                'Position',[0 70  600 30],...
                'BackGroundColor',bg,...
                'ForeGroundColor',fnt,...
                'Parent',warning);
        end
        
        function promote(this,pawn)
            if (this.gameController.whoPlays == 'w')
                bg = [1 1 1];
                fnt = [0 0 0];
            else
                bg = [0 0 0];
                fnt = [1 1 1];
            end
            warning = dialog('Name','Promotion','Position',[500 500 400 175],...
                'Resize','off',...
                'Color',bg);
            
            uicontrol('Style', 'popup',...
                'String', {'Rook','Bishop','Knight','Queen'},...
                'FontSize',22,...
                'Position', [140 0 120 90],...
                'Callback',{@popup_callback, this,pawn});
            uicontrol('Style', 'text', 'String', 'Promote your pawn to a different piece!',...
                'FontSize',22,...
                'Position',[0 100  400 50],...
                'BackGroundColor',bg,...
                'ForeGroundColor',fnt,...
                'Parent',warning)
            function popup_callback(hObject, ~,this,movedPiece)
                % Get value of popup
                selectedIndex = get(hObject, 'value');
                % Take action based upon selection
                player = upper(movedPiece.color);
                if selectedIndex  == 1
                    this.chessBoardModel.chessBoardMap(movedPiece.position(2),movedPiece.position(1)) = 'R';
                    set(this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button,'CData',ChessBoardGUI.createRGB(['resources/R' player '.png']) ,'UserData', Rook(this.chessBoardModel, movedPiece.color,movedPiece.position));
                elseif selectedIndex == 2
                    this.chessBoardModel.chessBoardMap(movedPiece.position(2),movedPiece.position(1)) = 'B';
                    set(this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button,'CData',ChessBoardGUI.createRGB(['resources/B' player '.png'])  ,'UserData', Bishop(this.chessBoardModel, movedPiece.color,movedPiece.position));
                elseif selectedIndex == 3
                    this.chessBoardModel.chessBoardMap(movedPiece.position(2),movedPiece.position(1)) = 'N';
                    set(this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button,'CData',ChessBoardGUI.createRGB(['resources/N' player '.png'])  ,'UserData', Knight(this.chessBoardModel, movedPiece.color,movedPiece.position));
                else
                    this.chessBoardModel.chessBoardMap(movedPiece.position(2),movedPiece.position(1)) = 'Q';
                    set(this.chessBoardModel.chessBoardBoxes(movedPiece.position(1),movedPiece.position(2)).button,'CData',ChessBoardGUI.createRGB(['resources/Q' player '.png'])  ,'UserData', Queen(this.chessBoardModel, movedPiece.color,movedPiece.position));
                end
                close;
            end
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