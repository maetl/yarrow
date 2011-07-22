<?php $this->wrap('layout'); ?>

	<h1><?php echo $meta['title']; ?></h1>

	<h2>Classes</h2>
	<ul>
	<?php foreach($objectModel->classes as $class): ?>
		<li><a href="<?php echo $class->relativeLink; ?>.html"><?php echo $class->getName(); ?></a></li>
	<?php endforeach ?>
	</ul>

