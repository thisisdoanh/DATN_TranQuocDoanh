part of '../slide_wipe_page.dart';

class BgRemoveSettingComponent extends StatelessWidget {
  const BgRemoveSettingComponent({super.key});

  Widget _buildItemCheckBox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppStyles.bodyLMedium14(AppColors.light100)),
        Checkbox(value: value, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlideWipeBloc, SlideWipeState>(
      buildWhen: (previous, current) {
        return previous.threshold != current.threshold ||
            previous.isSmoothMask != current.isSmoothMask ||
            previous.isEnhanceEdges != current.isEnhanceEdges;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).removeStrength,
              style: AppStyles.bodyLMedium14(AppColors.light100),
            ),
            Slider(
              value: state.threshold,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: state.threshold.toStringAsFixed(1),
              onChanged: (value) {
                context.read<SlideWipeBloc>().add(
                  SlideWipeEvent.updateThreshold(value),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: _buildItemCheckBox(
                    title: S.of(context).enhanceEdges,
                    value: state.isEnhanceEdges,
                    onChanged: (value) => context.read<SlideWipeBloc>().add(
                      SlideWipeEvent.updateEnhanceEdges(value ?? true),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildItemCheckBox(
                    title: S.of(context).smoothMask,
                    value: state.isSmoothMask,
                    onChanged: (value) => context.read<SlideWipeBloc>().add(
                      SlideWipeEvent.updateSmoothMask(value ?? true),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 20.w);
      },
    );
  }
}
