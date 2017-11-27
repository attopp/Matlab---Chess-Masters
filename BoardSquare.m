classdef BoardSquare < handle
    properties
        position;
        color;
        occupied;
    end
    methods
        function this = BoardSquare(position,color)
            this.occupied = false;
            this.position = position;
            this.color = color;
        end
        function occupy(this)
            this.occupied = true;
        end
    end
end