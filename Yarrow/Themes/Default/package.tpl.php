<?php $this->wrap('layout'); ?>

<div class="doc-header">
	<h1><?php echo $package->getName(); ?></h1>
</div>

<?php foreach($package->getClasses() as $class): ?>
<div class="doc-element">
	<h2><?php echo $class->getName(); ?></h2>
	<p><?php echo $class->getSummary(); ?></p>
</div>
<?php endforeach ?>

