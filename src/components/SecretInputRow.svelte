<script lang="ts">
	import { TextInput, Button } from 'carbon-components-svelte';
	import RemoveIcon from 'carbon-icons-svelte/lib/Close.svelte';

	export let key: string;
	export let value: string;
	export let onRemove: () => void;
	export let disabled: boolean;
</script>

<div class="secretRow">
	<TextInput
		required
		bind:value={key}
		size="xl"
		labelText="Secret label"
		placeholder="Enter secret label..."
	/>
	<TextInput
		required
		bind:value
		size="xl"
		labelText="Secret value"
		placeholder="Enter any value..."
	/>

	<div class="button">
		<Button icon={RemoveIcon} {disabled} on:click={onRemove} kind="tertiary">Remove</Button>
	</div>
</div>

<style>
	.secretRow {
		display: grid;
		grid-template-columns: 1fr 1fr auto;
		gap: 1rem;
	}

	.button {
		align-self: flex-end;
	}
</style>
