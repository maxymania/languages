local expr1 = {}
local exprtrail = {} 
--local json = require'json'

local function expr(ast,vm,al)
	local i
	local str = P.select(expr1,ast[0],vm,al)
	str = tostring(str)
	for i=1,ast.last,1
	do    str = P.select(exprtrail,ast[i],vm,al,str)    end
	return str
end
function expr1.chain(...) return "("..expr(...)..")" end
function expr1.call(ast,vm,al)
	local a,b
	local B = buffer()
	B:add(ast[0].content)
	B:add("(")
	a = ast[1]
	for i=0,a.last,1 do
		b = a[i]
		if i>0 then B:add(",") end
		--print(b,b[0],b[1])
		B:add(expr(b,vm,al))
	end
	B:add(")")
	return B:str()
end
function expr1.var(ast,vm,al)
	return vm[ast[0].content]
end
-- expr1.lit = U.content
function expr1.lit(ast,vm,al) return ast[0].content end
function expr1.assign(ast,vm,al)
	return tostring(vm[ast[0].content]).." = "..tostring(expr(ast[1],vm,al))
end

function expr1.deref(ast,vm,al) return "*"..tostring( P.select(expr1,ast[0],vm,al) ) end

function expr1.ref(ast,vm,al) return "&"..tostring( P.select(expr1,ast[0],vm,al) ) end
function expr1.unot(ast,vm,al) return "!"..tostring( P.select(expr1,ast[0],vm,al) ) end
function expr1.neg(ast,vm,al) return "-"..tostring( P.select(expr1,ast[0],vm,al) ) end
function expr1.cast(ast,vm,al)
	return "(".. U.dotype(ast[0]) ..")"..tostring( P.select(expr1,ast[1],vm,al) )
end


function exprtrail.op(ast,vm,al,str)
	local B = buffer()
	local i,a
	a = ast[0]
	for i=0,a.last,1
	do B:add(a[i].content) end
	
	return "("..str.." "..B:str().." ".. P.select(expr1,ast[1],vm,al) ..")"
end

function exprtrail.lkup(ast,vm,al,str)
	return str.."["..expr(ast[0],vm,al).."]"
end

function U.expr(ast,vm,al)
	return expr(ast,vm,al)
end

