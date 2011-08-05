
	
	<div><a href="<?php echo $file->getBaseLinkPrefix(); ?>/index.html">Index</a></div>

	<h1><?php echo $file; ?></h1>

	<h2>Classes</h2>

	<ul><?php foreach($file->classes as $class): ?>

		<li><a href="<?php echo $file->getBaseLinkPrefix(), $class->getRelativeLink(); ?>.html"><?php echo $class->name; ?></a></li>

	<?php endforeach ?></ul>

	<h2>Source</h2>

	<pre class="php"><code><?php echo htmlentities($file->source); ?></code></pre>