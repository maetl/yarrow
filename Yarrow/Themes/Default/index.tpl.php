<?php $this->wrap('layout'); ?>

	<div class="doc-header">
		<h1>Overview</h1>
	</div>

	<?php foreach($objectModel->getPackages() as $package): ?>
	<div class="doc-element">
		<h2><?php echo $package->getName(); ?></h2>
		<p>Classes:<?php foreach($package->getClasses() as $class): ?>&nbsp;<a href="<?php echo $class->relativeLink; ?>.html"><?php echo $class->getName(); ?></a>
		<?php endforeach; ?></p>
	</div>
	<?php endforeach ?>

