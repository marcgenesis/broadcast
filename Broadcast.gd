extends Node

# Debug variable, used to display internal messages or not
var debug : bool = false

# Force message registration
var force_registration : bool = true

# List of registered message
var registered_messages = []

# List of messages. Each message contains a list of listeners.
var messages = {}

# `send` broadcasts the message to the listeners and supplies the parameters and the broadcaster, if supplied
func send(message, params = {}):
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
					else:
						if debug: print("Not such method (", method, ") for listener ", listener.name)
		
			if debug: print("Successfully sent message: '", message, "' using params: ", params)
		else:
			if debug: print("No listeners for message ", message)
	else:
		if debug: print("Send failed. Message ", message, " doesn't exist")

# `listen` adds the listener to the list of listeners for the message that will call the method
func listen(message : String, listener : Object, method : String) -> bool:
	# Check if the message already exists in the list of listeners, if not add it.
	if !messages.has(message):
		messages[message] = {}
	
	# Check if the listener already exists, if not add it.
	if !messages[message].has(listener):
		messages[message][listener] = []
	
	# Add the method to the listener for the supplied message, if necessary
	if messages[message][listener].find(method) == -1:
		messages[message][listener].append(method)
	else:
		if debug: print("Listener ", listener.name, " already listening for message ", message, " with method ", method)
		return false

	# Success
	if debug: print("Listener ", listener.name, " now listening for message ", message, " with method ", method)
	return true

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
			if debug: print("Message ", message, " removed since all listeners were removed")
			
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
			if messages[message][listener].find(method) != -1:
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