extends Node

var danger = false
var rotating = false
var winner = ""
var players = []

func setPlayer(newPlayer):
	players.append(newPlayer)

func getPlayers():
	return players

func removePlayer(player):
	players.erase(player)

func setWinner(newWinner):
	winner = newWinner

func getWinner():
	return winner

func setDanger(newDanger):
	danger = newDanger

func isDanger():
	return danger

func setRotating(newRotating):
	rotating = newRotating

func isRotating():
	return rotating
