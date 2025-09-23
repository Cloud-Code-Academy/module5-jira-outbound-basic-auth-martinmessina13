public with sharing class JiraCalloutRetryQueueable implements Queueable, Finalizer {
	public JiraCalloutRetryQueueable() {
	}

	/**
	 * Finalizer execute method
	 * Triggers retry mechanism after job succeeds or fails
	 */
	public void execute(FinalizerContext context) {
		System.debug('entering finalizer context');
		System.debug('this.records: ' + this.records);
		if (!this.records.isEmpty()) {
			if (this.retryCount < MAX_RETRIES) {
				CustomLogger.insertLog(
					'Job ' +
						context.getAsyncApexJobId() +
						' failed. Retrying ' +
						this.records.size() +
						' records. Attempt #' +
						(this.retryCount + 1) +
						'.',
					'WARN'
				);
				JobParameters params = new JobParameters();
				params.batchSize = BATCH_SIZE;
				params.currentIndex = BATCH_SIZE;
				params.retryCount = this.retryCount + 1;
				System.debug('queued retry # ' + this.retryCount + 1);

				System.enqueueJob(new JiraCalloutQueueable(this.records, this.calloutType, params));
			} else {
				CustomLogger.insertLog(
					'Job ' +
						context.getAsyncApexJobId() +
						' failed after ' +
						MAX_RETRIES +
						' retried. ' +
						this.records.size() +
						' records could not be synced.',
					'ERROR'
				);
			}
		}
	}
}
