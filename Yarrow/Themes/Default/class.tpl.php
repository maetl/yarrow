<?php $this->wrap('layout'); ?>
	
<div>
	<h1><?php echo $class->name; ?></h1>
	<p><?php echo $class->summary; ?></p>
	<?php if ($class->file): ?>
	<p>In File: <a href="../<?php echo $class->file->getRelativeLink(); ?>"><?php echo $class->file->name; ?></a></p>
	<?php endif; ?>
</div>

<?php if ($class->description): ?>
<div class="doc-description">
	<h3>Description</h3>
	<p><?php echo nl2br($class->description); ?></p>
</div>
<?php endif; ?>

<?php if ($class->constants): ?>
<div class="doc-list doc-constants">
	<h2>Constants</h2>
	<?php foreach($class->constants as $constant): ?>
		<div class="doc-element">
			<pre class="php"><code><?php echo $constant->name; ?> = <?php echo $constant->value; ?></code></pre>
		</div>
	<?php endforeach ?>
</div>
<?php endif; ?>

<?php if ($class->methods): ?>
<div class="doc-list doc-methods">
	<h2>Methods</h2>
	<?php foreach($class->methods as $method): ?>
		<div class="doc-element">
			<h3><?php echo $method->name; ?></h3>
			<pre class="php"><code><?php echo $method->signature; ?></code></pre>
			<p><?php echo $method->text; ?></p>
		</div>
	<?php endforeach ?>
</div>
<?php endif; ?>