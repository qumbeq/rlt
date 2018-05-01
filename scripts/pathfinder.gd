# ============================== Path Finder ==============================
extends Node

#This node generates a path between origin and target based on parsed
#grid, start_point and target_point.

#It is really powerful as it can be changed to adapt to specific situations
#and favor certain routes above other possible ones if 'COST' is calculated
#differently, and so on.


#path finding

#get grid reference
var grid = {}
var locked = [] #array of vect2 points, return final route
var queue_list = {} #Queue used in the A* search algorithm

var to


#===================== Queue functions =====================

#assign position and respective priority to queue
func Queue_put(pos, priority):
	queue_list[pos] = priority

#gets highest priority (most efficient) position in queue
func Queue_get():
	
	#temporary array for pos cost
	var priority = []
	
	#for costs in queue
	for x in queue_list.values():
		priority.append(x)
	
	#sort in natural order and cut down to 1 item
	priority.sort(); priority.resize(1)
	
	#pops most efficient position
	for pos in queue_list:
		if queue_list[pos] == priority[0]:
			var requested_pos = pos
			queue_list.erase(requested_pos)
			return requested_pos

#===================== End Queue functions =====================




#A* search
func search(start_pos, target_pos):
	to = start_pos
	
	#if start_pos == target_pos, return empty array
	if start_pos == target_pos:
		return []
	
	#resets path A* 
	locked = []
	queue_list = {}
	
	#sets initial considerations
	Queue_put(start_pos, 0)
	var current
	var came_from = {} #dictionary for parent pos
	var cost_so_far = {} #dictionary with pos cost
	came_from[start_pos] = start_pos
	cost_so_far[start_pos] = 0

	#============================= main loop =============================  

	#while there are pos in queue list
	while !queue_list.empty():
		
		#current node is highest priority node in queue 
		current = Queue_get()
		
		#has current node found it's target?
		if current == target_pos:
			#print ('path found')
			break
		
		#for neighbours of current
		for pos in find_nearest(current):
			
			#defines cost (cost acumulated + cost to neighbour cell)
			var new_cost = cost_so_far[current] + int(current.distance_to(pos))
			
			#if pos hasn't been calculated before, or its more effective than before
			if !cost_so_far.has(pos) or new_cost < cost_so_far[pos]:
				
				#catalogue its cost
				cost_so_far[pos] = new_cost
				
				#defines its priority
				var priority = new_cost + int(target_pos.distance_to(pos))
				
				#put into queue
				Queue_put(pos, priority)
				
				#define parent position
				came_from[pos] = current
	
	#=========================== main loop end ===========================
	
	#if array doesn't have tgt_pos, failed, return empty array
	if !came_from.has(target_pos):
		#print("failed")
		return []
	
	#================  retrace route and return best path ================ 
	
	#path array is target position
	locked = [current]
	
	#while current position isn't start position
	while current != start_pos:
		current = came_from[current] #retrace last cell
		locked.insert(0, current) #insert at the start of the array
	
	#removes start_pos from path
	#locked.remove(0);
	
	return locked

func find_nearest(pos):
	
	var bp = []  #backward waypoints
	var try
	var fp = []  #forward waypoints
	try = Vector2(pos.x + 1, pos.y)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).x > 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x - 1, pos.y)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).x < 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x, pos.y + 1)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).y > 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x, pos.y - 1)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).y < 0:
			fp.append(try)
		else:
			bp.append(try)
	return fp+bp
	
func diff(pos):
	
	var diff = to - pos
	return diff
