<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
  <head>
    <title><?php echo $meta['title']; ?></title>
  </head>
  <body>
	
	<div><a href="<?php echo $file->getBaseLinkPrefix(); ?>/index.html">Index</a></div>

	<h1><?php echo $file; ?></h1>

	<h2>Classes</h2>

	<ul><?php foreach($file->getClasses() as $class): ?>

		<li><a href="<?php echo $file->getBaseLinkPrefix(), $class->getRelativeLink(); ?>.html"><?php echo $class->name; ?></a></li>

	<?php endforeach ?></ul>

	<h2>Source</h2>

	<?php echo highlight_string($file->getSource(), true); ?>
	
	
  </body>
</html>