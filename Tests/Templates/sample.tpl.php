<h1>PHP Template Sample</h1>

<?php foreach($objectModel->getClasses() as $class): ?>

	<h2><?php echo $class; ?></h2>

<?php endforeach ?>