################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../simbuild/micaz/c-support.o \
../simbuild/micaz/pytossim.o \
../simbuild/micaz/sim.o \
../simbuild/micaz/tossim.o 

C_SRCS += \
../simbuild/micaz/app.c 

OBJS += \
./simbuild/micaz/app.o 

C_DEPS += \
./simbuild/micaz/app.d 


# Each subdirectory must supply rules for building sources it contributes
simbuild/micaz/%.o: ../simbuild/micaz/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


