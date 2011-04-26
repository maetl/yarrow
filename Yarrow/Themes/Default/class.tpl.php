<h1><?php echo $class; ?></h1>

<?php foreach($class->getFunctions() as $func): ?>

	<h2><?php echo $func; ?></h2>
	
	<p><?php echo $func->getSummary(); ?></p>

<?php endforeach ?>