extends Node

var player:Player
var spawn:Marker3D
var can_hit_player:bool =  true

signal room_entered(room: Room)
signal room_exited(room: Room)
signal repair_compelted
signal start_clock
