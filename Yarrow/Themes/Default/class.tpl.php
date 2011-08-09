<?php $this->wrap('layout'); ?>
	
<h1><?php echo $class->name; ?></h1>

<p>In File: <a href="../<?php echo $class->file->getRelativeLink(); ?>"><?php echo $class->file->name; ?></a></p>

<?php if ($class->text): ?>
<div>
	<h2>Description</h2>
	<p><?php echo nl2br($class->text); ?></p>
</div>
<?php endif; ?>

<?php if ($class->constants): ?>
<div>
	<h2>Constants</h2>
	<?php foreach($class->constants as $constant): ?>
	<p><span class="constant-name"><?php echo $constant->name; ?></span> = <span class="constant-value"><?php echo $constant->value; ?></span></p>
	<?php endforeach ?>
</div>
<?php endif; ?>

<div>
	<h2>Methods</h2>
	<?php foreach($class->methods as $method): ?>
		<h3><?php echo $method->name; ?></h3>
		<p><code><?php echo $method->getSignature(); ?></code></p>
		<p><?php echo $method->summary; ?></p>
	<?php endforeach ?>
</div>
