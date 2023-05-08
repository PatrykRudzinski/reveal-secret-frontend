<script lang="ts">
	import {
		Button,
		CopyButton,
		InlineLoading,
		TextInput,
		ToastNotification
	} from 'carbon-components-svelte';
	import ContentWrapper from '../../../components/ContentWrapper.svelte';

	// TODO types
	/** @type {import('./$types').PageData} */
	export let data: { uuid: string };

	let isLoading = false;
	let dataToDisplay: any = null;
	let accessCode = '';
	let error: null | { title: string; caption: string } = null;

	// TODO types
	const revealSecret = async () => {
		isLoading = true;
		error = null;
		const response = await fetch(`http://localhost:3000/api/secret/reveal/${data.uuid}`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ accessCode })
		});

		const { status } = response;
		isLoading = false;

		switch (status) {
			case 201: {
				const { name, secrets } = await response.json();
				dataToDisplay = { name, secrets };
				break;
			}
			case 429: {
				error = {
					title: 'Too many attempts',
					caption: 'You have reached query limit, wait some time to try again'
				};
				break;
			}
			case 403: {
				error = {
					title: 'The given access code is invalid or the secret has already been displayed',
					caption: 'Try again'
				};
				break;
			}
			default: {
				error = { title: 'Something went wrong', caption: 'Try again' };
			}
		}
	};

	const reset = () => {
		dataToDisplay = null;
		accessCode = '';
		isLoading = false;
		error = null;
	};
</script>

<section>
	{#if !!dataToDisplay}
		<ContentWrapper>
			<h1>{dataToDisplay.name} secrets:</h1>
			<p class="info">
				This link is a one-time use. <br /> Save this secret because you won't see it again.
			</p>
			{#each dataToDisplay.secrets as secret (secret.value)}
				<p class="dataRow">
					<b>{secret.key}:</b>{secret.value}
					<CopyButton text={secret.value} feedback={`${secret.key} copied to clipboard!`} />
				</p>
			{/each}
		</ContentWrapper>
	{:else}
		<form on:submit={revealSecret}>
			<ContentWrapper>
				<h1>Get access to secret</h1>
				<TextInput
					required
					bind:value={accessCode}
					size="xl"
					labelText="Access code"
					placeholder="Provide safety code..."
				/>

				{#if error}
					<ToastNotification
						fullWidth
						title={error.title}
						caption={error.caption}
						on:close={reset}
					/>
				{/if}
				<div class="submitButton">
					{#if isLoading}
						<InlineLoading description="Checking access" />
					{:else}
						<Button disabled={!accessCode || !!error} kind="tertiary" size="lg" type="submit">
							Reveal secrets
						</Button>
					{/if}
				</div>
			</ContentWrapper>
		</form>
	{/if}
</section>

<!-- TODO not found fallback -->

<style>
	.info {
		font-weight: 100;
		font-size: 1.5rem;
	}

	.submitButton {
		justify-self: flex-end;
	}
</style>
