<script lang="ts">
	import { browser } from '$app/environment';
	import { goto } from '$app/navigation';
	import { Loading, CopyButton } from 'carbon-components-svelte';
	import type { CreatedSecret } from '../../types/CreatedSecret.type';
	import ContentWrapper from '../../components/ContentWrapper.svelte';

	let dataToDisplay: CreatedSecret;

	if (browser) {
		if (!history.state?.name) {
			setTimeout(() => goto('/'), 0);
		} else {
			dataToDisplay = history.state;
			setTimeout(() => goto('/created-successfully', { state: {} }), 0);
		}
	}
</script>

<section>
	{#if !!dataToDisplay}
		<ContentWrapper>
			<h1>Secret {dataToDisplay.name} created!</h1>
			<p class="dataRow"><b>Url address:</b> {dataToDisplay.url}</p>
			<p class="dataRow"><b>Access code:</b> {dataToDisplay.accessCode}</p>
			<div class="dataRow">
				<b>Copy access data </b>
				<CopyButton
					text={`Url: ${dataToDisplay.url}
Access code: ${dataToDisplay.accessCode}`}
					feedback={'Data copied to clipboard!'}
				/>
			</div>
		</ContentWrapper>
	{:else}
		<Loading />
	{/if}
</section>
