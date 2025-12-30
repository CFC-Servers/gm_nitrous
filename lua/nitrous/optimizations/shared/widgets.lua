	function widgets.PlayerTick()
	end

	function widgets.RenderMe()
	end

	hook.Remove("OnEntityCreated", "CreateWidgets")
	hook.Remove("EntityRemoved", "RemoveWidgets")
