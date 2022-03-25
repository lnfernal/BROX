--!strict

return {
	Simple =
	[[<!DOCTYPE html>
<html>
<body>

<h1>HTML (with css) Rendering in roblox</h1>
<code>CSS</code><pre>
	h1 {
		font-size: 12px;
		width: fit-content;
		height: fit-content;
		background-color: transparent;
		color: rgb(46, 46, 46);
		padding: 6px;
	}
	code {
		font-family: Code;
		font-size: 14px;
		width: fit-content;
		height: fit-content;
		background-color: rgba(0, 0, 0, 0.15);
		color: black;
		padding: 6px;
		border-radius: 6px;
	}
	pre {
		font-family: Code;
		font-size: 12px;
		width: fit-content;
		height: fit-content;
		background-color: transparent;
		color: black;
		text-align: left;
		padding: 12px;
	}
</pre>
<code>HTML</code>
<p>
	...
</p>

</body>
</html>]],
	Headings =
	[[<!DOCTYPE html>
<html>
<body>

<h1>This is heading 1</h1>
<h2>This is heading 2</h2>
<h3>This is heading 3</h3>
<h4>This is heading 4</h4>
<h5>This is heading 5</h5>
<h6>This is heading 6</h6>

</body>
</html>]],
	Paragraphs =
	[[<!DOCTYPE html>
<html>
<body>

<p>This is a paragraph.</p>
<p>This is another paragraph.</p>

</body>
</html>]],
	Links = 
	[[<!DOCTYPE html>
<html>
<body>

<h2>HTML Links</h2>
<p>HTML links are defined with the a tag:</p>

<a href="https://www.w3schools.com">This is a link</a>

</body>
</html>
]],
	ImagesAndAttributes = [[<!DOCTYPE html>
<html>
<body>

<h2>HTML Images</h2>
<p>HTML images are defined with the img tag:</p>

<img src="w3schools.jpg" alt="W3Schools.com" width="104" height="142">

</body>
</html>]],
	List = [[<!DOCTYPE html>
<html>
<body>

<h2>An Unordered HTML List</h2>

<ul>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ul>  

<h2>An Ordered HTML List</h2>

<ol>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ol> 

</body>
</html>]],
	Trimming = [[<!DOCTYPE html>
<html>
<body>

<p>In HTML, spaces and new lines are ignored:</p>

<p>

  My Bonnie lies over the ocean.

  My Bonnie lies over the sea.

  My Bonnie lies over the ocean.
  
  Oh,          bring back my Bonnie to me.

</p>

</body>
</html>]],
	Attributes2 = [[<!DOCTYPE html>
<html>
<body>

<h1>About W3Schools</h1>

<p title=About W3Schools>
You cannot omit quotes around an attribute value 
if the value contains spaces.
</p>

<p><b>
If you move the mouse over the paragraph above,
your browser will only display the first word from the title.
</b></p>

</body>
</html>]],
	Pre = [[<!DOCTYPE html>
<html>
<body>

<p>The pre tag preserves both spaces and line breaks:

haha
s
as
dassd</p>

<pre>
My Bonnie lies over the ocean.

   My Bonnie lies over the sea.

   My Bonnie lies over the ocean.
   
   Oh, bring back my Bonnie to me.
   
</pre>

</body>
</html>]]
} :: {string};