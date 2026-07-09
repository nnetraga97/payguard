package com.nnetraga.payguard.simulator.web.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.Instant;

public record AuthorizationRequest(
        @NotBlank String requestId,
        @NotBlank String accountToken,
        @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
        @NotBlank @Size(min = 3, max = 3) String currency,
        @NotBlank String merchantCategoryCode,
        @NotBlank @Size(min = 2, max = 2) String merchantCountry,
        @NotNull Channel channel,
        @NotNull Instant occurredAt,
        @NotBlank @Pattern(regexp = "^[0-9]{4}$") String cardLastFour) {
}
