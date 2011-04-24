<h1>PHP Template Sample</h1>

<?php foreach($ObjectModel->getClasses() as $class): ?>

	<h2><?php echo $class; ?></h2>

<?php endforeach ?>