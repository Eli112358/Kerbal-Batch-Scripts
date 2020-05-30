const data = {
	'KspDataCli.cmd': [
		{
			item: "select [..|index]",
			description: "Traverse the node tree. Select the node at the given index, or the previous node.",
		},
		{
			item: "list [clip[board]]",
			description: "",
		},
		{
			item: "set &lt;index&gt; &lt;text&gt;",
			description: "",
		},
		{
			item: "save [clip[board]]",
			description: "",
		},
		{
			item: "reload [file]",
			description: "(if file name contains 'clip', will load as clipboard data, replacing any previously copied data)",
		},
		{
			item: "copy &lt;type&gt; &lt;index&gt; [count [c]]",
			description: "or",
		},
		{
			item: "copy &lt;type&gt; &lt;index&gt; &lt;to_index&gt; &lt;i|e&gt;",
			description: "The type must be one is of: f,field,n,node. ( <i>I</i> nclude or <i>E</i> xclude ending index)",
		},
		{
			item: "paste &lt;type&gt; &lt;paste_to&gt; &lt;index_from&gt; [count [c]]",
			description: "or",
		},
		{
			item: "paste &lt;type&gt; &lt;paste_to&gt; &lt;index_from&gt; &lt;to_index&gt; &lt;i|e&gt;",
			description: "The type must be one is of: f,field,n,node. ( <i>I</i> nclude or <i>E</i> xclude ending index)",
		},
		{
			item: "eval &lt;text&gt;",
			description: "",
		},
		{
			item: "help [command]",
			description: "",
		},
		{
			item: "exit",
			description: "Exit the script. Note: does not save before exiting.",
		},
	],
	'KspProfiles.cmd': [
		{
			item: "activate &lt;profile&gt;",
			description: "Make KSP use this profile",
		},
		{
			item: "create &lt;profile&gt;",
			description: "Create new profile",
		},
		{
			item: "addMod &lt;profile&gt; &lt;mod&gt;",
			description: "Add a mod to a profile",
		},
		{
			item: "addModMgr &lt;profile&gt;",
			description: "Add the ModuleManager mod to a profile",
		},
		{
			item: "<strike>addModuleManager &lt;profile&gt;</strike> (Deprecated)",
			description: "(Deprecated, see 'addModMgr')",
		},
		{
			item: "help",
			description: "Display this help text",
		},
	],
};

export {
	data,
};
