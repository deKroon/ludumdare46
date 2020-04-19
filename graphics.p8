pico-8 cartridge // http://www.pico-8.com
version 19
__lua__

-- store directions for comparisons
left=0
right=1
up=2
down=3

mobtypes = {}
mobtypes.snail={}
mobtypes.snail.speed=0.2
mobtypes.snail.step = 6
mobtypes.snail.spr_dir=left
mobtypes.snail.sprites = {144,145,146}
mobtypes.bug={}
mobtypes.bug.speed=0.4
mobtypes.bug.step = 3
mobtypes.bug.spr_dir=up
mobtypes.bug.sprites = {160,161,162}

function makemob(type, x, y, direction)
	newmob={}
	newmob.x=x
	newmob.y=y
	newmob.speed=type.speed
	newmob.direction=direction
	newmob.animations={}
	newmob.animations.tick=0
	newmob.animations.frame=0
	newmob.animations.step=type.step
	newmob.animations.spr_xflip=isxflipped(type, direction)
	newmob.animations.spr_yflip=isyflipped(type, direction)
	newmob.animations.sprites=type.sprites
	return newmob
end

-- TODO: rewrite, stupidly long
function isxflipped(type, direction)
	if direction==left then
		if type.spr_dir==right then
			return true
		end
	end
	if direction==right then
		if type.spr_dir==left then
			return true
		end
	end
	return false
end

function isyflipped(type, direction)
	if direction==up then
		if type.spr_dir==down then
			return true
		end
	end
	if direction==down then
		if type.spr_dir==up then
			return true
		end
	end
	return false
end


-- table of mobs to draw to screen
local mobs = {}

function addmob(mob)
	mobs[#mobs+1]=mob
end

function animate(obj)
	obj.animations.tick=(obj.animations.tick+1)%obj.animations.step
	if(obj.animations.tick==0) then
		obj.animations.frame=obj.animations.frame%#obj.animations.sprites+1
	end
	spr(obj.animations.sprites[obj.animations.frame],obj.x,obj.y,1,1,obj.animations.spr_xflip,obj.animations.spr_yflip)
end

function move(obj)
	if obj.direction==0 then
		obj.x-=obj.speed
	elseif obj.direction==1 then
		obj.x+=obj.speed	
	elseif obj.direction==2 then
		obj.y-=obj.speed
	elseif obj.direction==3 then
		obj.y+=obj.speed
	end
end 

function isoffscreen(obj)
	if (obj.x<-8) or (obj.x>128) or (obj.y<-8) or (obj.y>128) then
		return true
	else
		return false
	end
end

function drawmobs()
	for mob in all(mobs) do 
		animate(mob)
		if isoffscreen(mob) then
			del(mobs, mob)
		end
	end
end

function updatemobs()
	for mob in all(mobs) do
		move(mob)
	end
end

function _init()
	mobs = {}
	newsnail = makemob(mobtypes.snail, 64, 64, right)
	newbug = makemob(mobtypes.bug, 64, 64, down)
	addmob(newsnail)
	addmob(newbug)
end

function _update()
	updatemobs()
end

function _draw()
	cls()
	drawmobs()
end
__gfx__
00000000000001100000000000000000000222222222222222222222000222222222222222222222000000000000000000000000000000000000000000000000
0000000000001100000000000000000000029999999999999aaa77a20002222222222222222222220000000000000ccc00000000000000000000000000000000
00700700000110000000000000000000002911111111111111111a200022111111111111111112200000cccc0000cc0000009009090090000000000000000000
00077000001100000000000000000000002900000000000000000a20002211111111111111111220ccccc0000000c00000000909090900000000000000000000
0007700001100000000000000000000002911111111111111111a2000221111111111111111122000000000000000000009000aaaaa000900000000000000000
0070070011000000000000000000000002911111111111111111a20002211111111111111111220000000000cccc000000090aaaaaaa09000000000000000000
000000001000000100000000000000002911111111111111111a200022111111111111111112200000000cccc00000000000aaaaaaaaa0000000000000000000
00000000000000110000000000000000222222222222222222222000222222222222222222222000000ccc0000000ccc0099aaaaaaaaa0000000000000000000
0000888888888000000088888888800000008888888880000000888888888000000088888888800000000000000ccc000000aaaaaaaaa9900000000000000000
000888888888888000088888888888800008888888888880000888888888888000088888888888800000000000cc00000000aaaaaaaaa0000000000000000000
00088888888888800008888888888880000888888888888000088888888888800008888888888880000000ccc000000000090aaaaaaa09000000000000000000
008888888ffff880008888888ffff880008888888ffff880008888888ffff880008888888ffff8800000ccc000000000009000aaaaa000900000000000000000
00888888fffffff000888888fffffff000888888fffffff000888888fffffff000888888fffffff00000000000ccc00000000909090900000000000000000000
0088888ffffffff00088888ffffffff00088888ffffffff00088888ffffffff00088888ffffffff00c00c00000c0000000009009090090000000000000000000
088888ffccffccf0088888ffccffccf0088888ffccffccf0088888ffccffccf0088888ffccffccf00ccc00000000000000000000000000000000000000000000
08888fffc7ffc7f008888fffc7ffc7f008888fffc7ffc7f008888fffc7ffc7f008888fffc7ffc7f0000000000000000000000000000000000000000000000000
0888fffffffffff00888fffffffffff00888fffffffffff00888fffffffffff00888fffffffffff0000000000000000000000000000000000000000000000000
0888ffffff88fff00888ffffff88fff00888ffffff88fff00888ffffff88fff00888ffffff88fff0000000000000000000000000000000000000000000000000
088000fffffff000088000fffffff000088000fffffff000088000fffffff000088000fffffff000000888000088800000000000000000000000000000000000
88800000eeee0f0088800000eeee000088800000eeee0f0088800000eeee0f0088800000eeee0000008888888888880000000000000000000000000000000000
0080000feeeef000008000ffeeeeff000080000feeeef0000080000feeeef00000800000ffeeff00088888888778888000000000000000000000000000000000
008000feeeeee0000080000eeeeee000008000feeeeee000008000feeeeee0000080000eeeeee000888888888877888000000000000000000000000000000000
0000000eeeeee0000000000eeeeee0000000000eeeeee0000000000eeeeee0000000000eeeeee000888888888888788000000000000000000000000000000000
00000000ff0ff00000000000ff0ff00000000000000ff00000000000ff00000000000000ff0ff000888888888888888000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000088888888888880000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000088888888888880000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888800000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000888888880000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000088888800000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000008888000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeee00ee00000000eee000ee000ee0eeeeeee0eeeeee00eeeeeee0e7000e70ee7777e0ee000000ee000ee0eeeeeee0eeeeeee0ee7777e0ee000ee000000220
e77777e0e70000000ee77e00e7e00e70e7777770e77777e0e7777770e7e0ee70e7000e70e7000000e7000e70e7777770e7777770e7000e70e7e00e7000002200
e7000070e7000000ee7007e0e77e0e70000e7000e7000070e7eeee000e70e700e7000e70e7000000e7000e70000e7000000e7000e7000e70e77e0e7000022000
e7eeee70e7000000e7eeee70e707ee70000e7000e7eeee70e77777000e70e700e7000e70e7000000e7000e70000e7000000e7000e7000e70e707ee7000220000
e7777700e7000000e7777770e7007e70000e7000e7777700e70000000e70e700e7000e70e7000000e7000e70000e7000000e7000e7000e70e7007e7002200000
e7000000e7eeeee0e7000e70e7000770000e7000e700e7e0e7eeeee00e7ee700e7eeee70e7eeeee0e7eeee70000e7000eeee7ee0e7eeee70e700077022000000
e7000000e7777770e7000e70e7000770000e7000e7000e70e777777000e770000e777700e7777770e7777770000e7000e77777700e777700e700077020000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3333333333333333333333333333b3333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
b333333333333333333333333333333b333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
b333333333b333333333333333b3333b333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
33333333333b333333333333333b333333bb33333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
333333b3333b3333333333b3333b33333333b33333333b3333b33333000000000000000000000000000000000000000000000000000000000000000000000000
33333b333333333333333b333333333333333b333333b3b33b333333000000000000000000000000000000000000000000000000000000000000000000000000
33333b333333333333333b333333333333333b333333b3333b333333000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000888000008880c0c0888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088998c0c88998f0f8899800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c89889f0f89889f0f8988900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff88894fff88894fff8889400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fff44400fff44400fff444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ffffff00ffffff0ffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20800802008008002080080200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203b0202203b0220203b02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003bbb00003bbb00003bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0233bb200233bb200033bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20367b0220367b0202367b2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007767000077670000376b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2773b6722773b6720077660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003b0000003b0000273b72000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0040414243444041424344000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0045464748414a444c4843000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
