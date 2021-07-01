-- title:  Platformer Demo
-- author: trelemar / pkh
-- desc:   Demo made for tutorial @ infinitelimit.net
-- script: lua
-- input:  gamepad

function solid(x,y)
	return solids[mget((x)//8,(y)//8)]
end

function init()
	solids={[1]=true,[3]=true}
	p={
		x=120,
		y=68,
		vx=0, --Velocity X
		vy=0, --Velocity Y
	}
end

init()
function TIC()
	if btn(2) then p.vx=-1
	elseif btn(3) then p.vx=1
	else p.vx=0
	end

	if solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy) or solid(p.x+p.vx,p.y+7+p.vy) or solid(p.x+7+p.vx,p.y+7+p.vy) then
		p.vx=0
	end

	if solid(p.x,p.y+8+p.vy) or solid(p.x+7,p.y+8+p.vy) then
		p.vy=0
	else
		p.vy=p.vy+0.2
	end

	if p.vy==0 and btnp(4) then p.vy=-2.5 end

	if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy) or solid(p.x+7+p.vx,p.y+p.vy)) then
		p.vy=0
	end

	p.x=p.x+p.vx
	p.y=p.y+p.vy

	cls()
	map()
	rect(p.x,p.y,8,8,15)
end
