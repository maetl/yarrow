<?php $this->wrap('layout'); ?>
	
<h1><?php echo $class; ?></h1>

<p><?php echo $class->summary; ?></p>

<p>In File: <a href="../<?php echo $class->file->getRelativeLink(); ?>"><?php echo $class->file->name; ?></a></p>

<div>
	<h3>Description</h3>
	
	<p><?php echo nl2br($class->text); ?></p>
	
</div>

<?php foreach($class->methods as $method): ?>

	<h3><?php echo $method; ?></h3>
	<p><?php echo $method->summary; ?></p>


<?php endforeach ?>
	
