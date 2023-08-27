function [ IM ] = getScale( IM)
IM = IM - min(IM(:)) ;
IM = IM / max(IM(:)) ;
end

