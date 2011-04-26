<h1><?php echo $meta['title']; ?></h1>

<?php foreach($objectModel->getClasses() as $class): ?>

	<h2><?php echo $class; ?></h2>

<?php endforeach ?>