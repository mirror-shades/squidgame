extends Node

var danger = false
var rotating = false

func setDanger(newDanger):
	danger = newDanger

func isDanger():
	return danger

func setRotating(newRotating):
	rotating = newRotating

func isRotating():
	return rotating
