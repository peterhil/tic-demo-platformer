-- script: lua

function solid(p)
	return solids[mget((p.x)//8, (p.y)//8)]
end

function add(p, q, d)
	local default = {x=0, y=0}
	setmetatable(d, {__index=default})

	local dx, dy =
		d[1] or d.x,
		d[2] or d.y

	local x = p.x + q.x + dx
	local y = p.y + q.y + dy

	return {x=x, y=y}
end

function init()
	solids={[1]=true, [3]=true}
	p={
		x=120,
		y=68,
	}
	v={
		x=0,  --Velocity X
		y=0,  --Velocity Y
	}
end

init()

function TIC()
	if btn(2) then v.x=-1
	elseif btn(3) then v.x=1
	else v.x=0
	end

	if solid(add(p, v, {})) or solid(add(p, v, {x=7, y=0})) or solid(add(p, v, {x=0, y=7})) or solid(add(p, v, {x=7, y=7})) then
		v.x=0
	end

	if solid({ x=p.x, y=p.y+8+v.y }) or solid({ x=p.x+7, y=p.y+8+v.y }) then
		v.y=0
	else
		v.y=v.y+0.2
	end

	if v.y==0 and btnp(4) then v.y=-2.5 end

	if v.y<0 and (solid({ x=p.x+v.x, y=p.y+v.y }) or solid({ x=p.x+7+v.x, y=p.y+v.y })) then
		v.y=0
	end

	p.x=p.x+v.x
	p.y=p.y+v.y

	cls()
	map()
	rect(p.x, p.y, 8, 8, 12)
end
