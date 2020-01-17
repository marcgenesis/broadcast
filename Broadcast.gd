extends Node

# Debug variable, used to display internal messages or not
var debug : bool = false

# Force message registration
var force_registration : bool = false

# List of registered message
var registered_messages = []

# List of messages. Each message contains a list of listeners.
var messages = {}

# `get_messages` returns a list of all the messages
func get_messages() -> Dictionary:
	return messages

# `get_listeners` returns a list of listeners for the supplied message
func get_listeners(message : String) -> Dictionary:
	if messages.has(message):
		return messages[message]
	else:
		return {}

# `get_methods` returns a list of method used by a listener for the supplied message
func get_methods(message : String, listener : Object) -> Dictionary:
	if messages.has(message) && messages[message].has(listener):
		return messages[message][listener]
	else:
		return {}

# `send` broadcasts the message to the listeners and supplies the parameters and the broadcaster, if supplied
func send(message : String, params : Dictionary = {}) -> bool:
	# Check if the message exists
	if messages.has(message):
		# If it exists, broadcast to every listener
		if messages[message].size() > 0:
			for listener in messages[message]:
				# Broadcast to each method
				for method in messages[message][listener]:			
					if listener.has_method(method):
						#If the method exists, broadcast the message
						listener.call(method, params)
						
						# Remove if it is suppose to fire only once
						if messages[message][listener][method]:
							messages[message][listener].erase(method)
							if debug: print("Method ", method, " fired once for listener ", listener.name, " on message ", message, " and was removed.")
					else:
						if debug: print("Not such method (", method, ") for listener ", listener.name)
		
				# If the listener doesn't have any methods left, remove it from the message
				if messages[message][listener].size() == 0:
					messages[message].erase(listener)
		
			if debug: print("Successfully sent message: '", message, "' using params: ", params)
			return true
		else:
			if debug: print("No listeners for message ", message)
			return false
	else:
		if debug: print("Send failed. Message ", message, " doesn't exist")
		return false

# `is_listening` verify if the listener is listening to the supplied message. Optionally it can verify if it is listening using a specific method
func is_listening(message : String, listener : Object, method = "") -> bool:
	if method == "":
		# Check if the listerner is listening to the supplied message.
		if messages.has(message) && messages[message].has(listener):
			return true
	else:
		# Check if the listerner is listening to the supplied message using the supplied method
		if messages.has(message) && messages[message].has(listener) && messages[message][listener].has(method):
			return true
	
	# If the function hasn't returned yet, it means the listener isn't listening
	return false

# `listen` adds the listener to the list of listeners for the message that will call the method
func listen(message : String, listener : Object, method : String, once = false) -> bool:
	# If force_registration is on, make sure the message is registered before listening
	if force_registration:
		# Check if the message is registered
		if registered_messages.find(message) == -1:
			if debug: print("Listen failed. Force registration is on. Message ", message, " not registered.")
			return false
	
	# Check if the message already exists in the list of listeners, if not add it.
	if !messages.has(message):
		messages[message] = {}
	
	# Check if the listener already exists, if not add it.
	if !messages[message].has(listener):
		messages[message][listener] = {}
	
	# Add the method to the listener for the supplied message, if necessary
	if !messages[message][listener].has(method):
		messages[message][listener][method] = once
	else:
		if debug: print("Listener ", listener.name, " already listening for message ", message, " with method ", method)
		return false

	# Success
	if debug: print("Listener ", listener.name, " now listening for message ", message, " with method ", method, ". Fire once: ", once)
	return true

# `listen_once` adds the listener to the message with a given method. It will be removed once called.
func listen_once(message : String, listener : Object, method : String) -> bool:
	var success = listen(message, listener, method, true)
	return success

# `ignore_all` removes the listener from the supplied message
func ignore_all(message : String, listener : Object) -> bool:
	# Check for the message
	if messages.has(message):
		# Remove the listener
		messages[message].erase(listener)
		if debug: print("Successfully removed listener ", listener.name, " from message ", message)
		
		# If their are no more listener, remove the message
		if messages[message].size() == 0:
			messages.erase(message)
			if debug: print("Message ", message, " purged since all listeners were removed")
			
		return true
	else:
		if debug: print("Ignore all failed for listener ", listener.name, ". Message ", message, " doesn't exist")
		return false
	
# `ignore` removes the method listed from the listener of the specified message
func ignore(message : String, listener : Object, method : String) -> bool:
	# Check for the message
	if messages.has(message):
		# Check for the listener
		if messages[message].has(listener):
			# Remove the method if it exists
			if messages[message][listener].has(method):
				if debug: print("Successfully removed method ", method, " for listener ", listener.name, " for message ", message)
				return true
			else:
				if debug: print("Cannot remove method ", method, ". No such method for listener ", listener.name, " for message ", message)
				return false
		else:
			if debug: print("Ignore failed. Listener ", listener.name, " not listening to message ", message)
			return false
	else:
		if debug: print("Ignore failed for listener ", listener.name, ". Message ", message, " doesn't exist")
		return false

# `is_registered` verify is the supplied message is already registered and returns the answer
func is_registered(message : String) -> bool:
	if registered_messages.find(message) == -1:
		return false
	else:
		return true

# `register` registers a message to the list of registered messages used when the "force_registration" is set to true.
func register(message : String) -> bool:
	if registered_messages.find(message) == -1:
		registered_messages.append(message)
		if debug: print("Message ", message, " registered successfully")
		return true
	else:
		if debug: print("Message ", message, " is already registered")
		return false

# `unregister` removes a message from the list of registered messages
func unregister(message : String) -> bool:
	if registered_messages.find(message) == -1:
		if debug: print("Unregister failed. Message ", message, " is not registered.")
		return false
	else:
		registered_messages.erase(message)
		if debug: print("Message ", message, " unregistered successfully")
		return true