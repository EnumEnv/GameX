--[=[
    TaskThreadManager is a module to manage tasks with unique identifiers. 
    It allows creating, starting, stopping, refreshing, and binding functions to tasks.
    
    Functions:
        - CreateTask(identifier: string): Creates a new task.
        - BindFunctionToTask(identifier: string, callback: function): Binds a function to a task.
        - RefreshTask(identifier: string): Refreshes a task.
        - StopTask(identifier: string, deleteData: boolean?): Stops a task and optionally deletes its data.
        - StartTask(identifier: string): Starts a task.
]=]

local TaskThreadManager = {}
local Threads = {}
local CollectedBinds = {}

--[=[
    Creates a new task with the given identifier.
    
    @param identifier string: The unique identifier for the task.
--]=]
function TaskThreadManager.CreateTask(identifier: string)
	Threads[identifier] = function() end
end

--[=[
    Checks if a task identifier exists inside threads.

    @param identifier string: The unique identifier for the task to look for.
--]=]
function TaskThreadManager.TaskExists(identifier: string)
    return Threads[identifier] ~= nil
end

--[=[
    Binds a callback function to an existing task.
    
    @param identifier string: The unique identifier for the task.
    @param callback function: The function to be bound to the task.
--]=]
function TaskThreadManager.BindFunctionToTask(identifier: string, callback: () -> ())
	assert(Threads[identifier], "Could not find task of identifier:", identifier, "to bind callback to.")

	CollectedBinds[identifier] = callback
	Threads[identifier] = callback
end

--[=[
    Refreshes an existing task, restarting it with its bound callback.
    
    @param identifier string: The unique identifier for the task.
--]=]
function TaskThreadManager.RefreshTask(identifier: string)
	assert(Threads[identifier], "Could not find task of identifier:", identifier, "to refresh.")

	task.cancel(Threads[identifier])
	Threads[identifier] = CollectedBinds[identifier]
end

--[=[
    Stops an existing task and optionally deletes its data.
    
    @param identifier string: The unique identifier for the task.
    @param deleteData boolean: Whether to delete the task data (optional).
--]=]
function TaskThreadManager.StopTask(identifier: string, deleteData: boolean?)
	assert(Threads[identifier], "Could not find task of identifier:", identifier, "to stop.")

	local _, _ = pcall(function()
		task.cancel(Threads[identifier])
	end)

	if deleteData then
		Threads[identifier] = nil

		if not CollectedBinds[identifier] then
			return
		end

		CollectedBinds[identifier] = nil
	end
end

--[=[
    Starts an existing task.
    
    @param identifier string: The unique identifier for the task.
--]=]
function TaskThreadManager.StartTask(identifier: string)
	assert(Threads[identifier], "Could not find task of identifier:", identifier, "to start.")

	Threads[identifier] = task.spawn(Threads[identifier])
end

return TaskThreadManager
