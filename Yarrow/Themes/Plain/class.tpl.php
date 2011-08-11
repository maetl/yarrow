<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
  <head>
    <title><?php echo $meta['title']; ?></title>
  </head>
  <body>
	
	<h1><?php echo $class; ?></h1>

	<p><?php echo $class->summary; ?></p>
	
	<p>In File: <a href="../<?php echo $class->file->getRelativeLink(); ?>"><?php echo $class->file->name; ?></a></p>

	<?php foreach($class->methods as $method): ?>

		<h2><?php echo $method; ?></h2>
		<p><?php echo $method->summary; ?></p>


	<?php endforeach ?>
	
	
  </body>
</html>

