# BROX

<a href="https://roblox.com">ROBLOX</a> HTML and css (subset) renderer, written in <a href="https://luau-lang.org">luau</a>.

## Contributing

Most contributions can be done in `src/BROX/CSS/Convert.lua` that is the file where we convert css properties to ROBLOX gui properties. You can add or fix any of those and send a PR. There are a lot of warnings that also need to be fixed, a lot of FIXME's and TODO's scattered throughout the code. You can run the code and try to find where it logs 'Not implemented' and try to implement those if you can.

## Progress

### Current State

#### Implemented CSS Properties:
*Ones marked with '?' are only partially implemented*
- color
- background-color
- font-size
- ?width
- ?height
- ?font-family
- text-align
- ?padding
- border-radius

<img src="https://i.imgur.com/TudDVjq.png">

```html
<!DOCTYPE html>
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
</html>
```

```css
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
```