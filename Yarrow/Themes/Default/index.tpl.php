<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
  <head>
    <title><?php echo $meta['title']; ?></title>
  </head>
  <body>

	<h1><?php echo $meta['title']; ?></h1>

	<ul>
	<?php foreach($objectModel->getClasses() as $class): ?>
		<li><a href="<?php echo $class->relativeLink; ?>.html"><?php echo $class; ?></li>
	<?php endforeach ?>
	</ul>

  </body>
</html>

