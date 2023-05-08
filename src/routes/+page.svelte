<script lang="ts">
	import { TextInput, Button, ToastNotification } from 'carbon-components-svelte';
	import Add from 'carbon-icons-svelte/lib/Add.svelte';
	import { goto } from '$app/navigation';
	import type { CreatedSecret } from '../types/CreatedSecret.type';
	import SecretInputRow from '../components/SecretInputRow.svelte';
	import ContentWrapper from '../components/ContentWrapper.svelte';
	import type { Secret } from '../types/Secret.type';

	let name = '';
	let accessCode = '';
	let lastId = 0;
	let error: null | string = null;

	let secrets: (Secret & { id: number })[] = [{ id: lastId, key: '', value: '' }];

	const addSecretSet = () => {
		lastId++;
		secrets = [...secrets, { id: lastId, key: '', value: '' }];
	};

	const removeSecretSet = (idToRemove: number) => {
		secrets = secrets.filter(({ id }) => id !== idToRemove);
	};

	const submit = async () => {
		try {
			error = null;

			const body = { name, accessCode, secrets: secrets.map(({ key, value }) => ({ key, value })) };

			const response = await fetch(`${import.meta.env.VITE_API_URL}/secret/create`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(body)
			});
			const { uuid } = await response.json();

			const state: CreatedSecret = {
				accessCode,
				name,
				url: `${import.meta.env.VITE_APP_URL}/reveal/${uuid}`
			};
			setTimeout(() => goto('/created-successfully', { state }), 0);
		} catch (e) {
			error = 'Something went wrong.';
		}
	};
</script>

<svelte:head>
	<title>Create a secret</title>
	<meta name="description" content="Create a secret" />
</svelte:head>

<ContentWrapper>
	<h1>Create a secret</h1>
	<form class="form" on:submit={submit}>
		<div class="mainInfo">
			<TextInput
				required
				bind:value={name}
				size="xl"
				labelText="Secret group name"
				placeholder="Enter any name..."
			/>
			<TextInput
				required
				bind:value={accessCode}
				size="xl"
				labelText="Secret access code"
				placeholder="Enter safety code..."
			/>
		</div>
		<div class="divider" />
		{#each secrets as secret (secret.id)}
			<SecretInputRow
				disabled={secrets.length === 1}
				bind:key={secret.key}
				bind:value={secret.value}
				onRemove={() => removeSecretSet(secret.id)}
			/>
		{/each}
		<div class="buttonAdd">
			<Button on:click={addSecretSet} kind="tertiary" icon={Add}>Add another</Button>
		</div>
		{#if error}
			<ToastNotification
				fullWidth
				title="Network Error"
				subtitle={error}
				caption={new Date().toLocaleString()}
			/>
		{/if}
		<div class="buttonSubmit">
			<Button size="lg" type="submit" kind="tertiary">Create</Button>
		</div>
	</form>
</ContentWrapper>

<style>
	.form {
		display: grid;
		gap: 1rem;
	}

	.mainInfo {
		display: grid;
		grid-template-columns: repeat(2, auto);
		gap: 1rem;
	}

	.buttonAdd {
		margin-top: 3rem;
		justify-self: flex-end;
	}

	.buttonSubmit {
		margin-top: 9rem;
		display: flex;
		justify-content: flex-end;
	}
</style>
